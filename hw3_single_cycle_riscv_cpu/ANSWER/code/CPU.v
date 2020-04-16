// Please include verilog file if you write module in other file
`include "Decoder.v"
`include "PC.v"
`include "Register.v"
`include "SignExtend.v"
`include "ALUCtrl.v"
`include "ALU.v"
`include "BranchCtrl.v"

module CPU(
    input             clk,
    input             rst,
    input      [31:0] data_out,
    input      [31:0] instr_out,
    output            instr_read,
    output            data_read,
    output     [31:0] instr_addr,
    output     [31:0] data_addr,
    output reg [3:0]  data_write,
    output reg [31:0] data_in
);

/* Add your design */
parameter BYTE=3'b000,
          HWORD=3'b001,
          BYTE_U=3'b010,
          HWORD_U=3'b011,
          WORD = 3'b100;

// for program counter
wire  [31:0]  pc_out;
reg   [31:0]  pc_in ;
// for register file 
wire  [31:0]  data1;
wire  [31:0]  data2;
wire  [31:0]  w_data;
wire          RegWrite;
// for Imm 
wire  [2:0]   ImmType;
wire  [31:0]  extendnum;
// for MemWrite 
wire MemRead;
wire MemWrite;
// for other siganl
wire PCtoRegSrc,ALUSrc,RDSrc,MemtoReg;
// for Branch
wire  [1:0]   Branch;
wire  [1:0]   branchCtrl;
// for ALU 
wire  [2:0 ]  ALUOp;
wire  [31:0]  ALUReg;
wire  [3:0]   OpCtrl;
wire  [31:0]  ALUOut;
wire  [31:0]  PCReg ;
wire  [31:0]  result ;
wire  [31:0]  PCIMM;
wire          ZeroFlag;
wire  [2:0]   data_type;
wire flush;
wire stall;
reg   [31:0]  data_out_cpu;
reg [31:0]pipe_instr;
reg [31:0]pipe_pc;
reg [31:0]pipe1_pc;
reg [31:0]tmp_instr;
reg cnt ;
reg cnt_flush;

assign flush = branchCtrl != 2'b10;
assign stall = (MemRead & cnt == 1'b0); 
assign instr_addr = pc_out ;
assign instr_read = ~stall;//1'b1;
assign PCIMM      = pipe_pc+extendnum;
assign PCReg      = PCtoRegSrc ? PCIMM:pipe_pc+4;
assign result     = RDSrc ? PCReg:ALUOut;
assign ALUReg     = ALUSrc? data2 : extendnum;
assign data_read  = MemRead & cnt!= 1'b1;
assign data_addr  = ALUOut;
assign w_data     = MemtoReg ? result: data_out_cpu;


always@(posedge clk or posedge rst)begin
    if(rst)
        pipe1_pc <= 32'b0;
    else if (~stall)
        pipe1_pc <= pc_out;
end

always@(posedge clk or posedge rst) begin
    if(rst)
        cnt <= 1'b0;
    else 
        cnt <= stall;
end

always@(posedge clk or posedge rst) begin
    if(rst)
        cnt_flush <= 1'b0;
    else 
        cnt_flush <= flush;
end

always@(posedge clk or posedge rst) begin
    if(rst)
        tmp_instr<= 32'b0;
    else 
        tmp_instr<=instr_out;
end

always@(posedge clk or posedge rst )begin
    if(rst)begin
        pipe_instr <= 32'b0;
        pipe_pc <= 32'b0;
    end
    else if(~stall) begin
        pipe_instr<= (flush | cnt_flush)? 32'b0 : 
                     (cnt)              ? tmp_instr:
                                          instr_out;
        pipe_pc <= pipe1_pc; 
    end
end

always@(*) begin
    case(branchCtrl)
        2'b00:
            pc_in = ALUOut;
        2'b01:
            pc_in = PCIMM;
        2'b10:
            pc_in = pc_out + 4;
        default:
            pc_in = 32'b0;
    endcase
end

always@(*) begin
    data_write = 4'b0;
    if(MemWrite)begin
        case(data_type)       
            BYTE:data_write[data_addr[1:0]]=1'b1;
            HWORD:data_write[{data_addr[1],1'b0}+:2] = 2'b11;
            default:data_write = 4'hf; 
        endcase 
    end
end

always@(*) begin
    data_in = 32'b0;
    case(data_type)
            BYTE:data_in[{data_addr[1:0],3'b0}+:8] = data2[7:0];
            HWORD:data_in[{data_addr[1],4'b0}+:16]=data2[15:0];
            default:data_in=data2; 
    endcase
end

always@(*) begin
    data_out_cpu = 32'b0;
    case(data_type)
          BYTE:begin
            data_out_cpu[7:0] = data_out[{data_addr[1:0],3'b0}+:8];
            data_out_cpu[31:8] = {24{data_out_cpu[7]}};
          end
          HWORD:begin
            data_out_cpu[15:0] = data_out[{data_addr[1],4'b0}+:16];
            data_out_cpu[31:16] = {16{data_out_cpu[15]}};
          end
          BYTE_U:data_out_cpu[7:0] = data_out[{data_addr[1:0],3'b0}+:8];
          HWORD_U:data_out_cpu[15:0] = data_out[{data_addr[1],4'b0}+:16];
          default: data_out_cpu=data_out;
    endcase
end

PC programpc_out (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .pc_in(pc_in),
    .pc_out(pc_out)
);

Decoder decoder (
    .rst(rst),
    .clk(clk),
    .opcode(pipe_instr[6:0]),
    .ImmType(ImmType),
    .RegWrite(RegWrite),
    .PCtoRegSrc(PCtoRegSrc),
    .ALUSrc(ALUSrc),
    .RDSrc(RDSrc),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .Branch(Branch),
    .ALUOp(ALUOp)
);

Register register (
    .rst(rst),
    .clk(clk),
    .rs1(pipe_instr[19:15]),
    .rs2(pipe_instr[24:20]),
    .rd(pipe_instr[11:7]),
    .r_data1(data1),
    .r_data2(data2),
    .w_data(w_data),
    .w_signal(RegWrite)
);

SignExtend signExtend(
    .rst(rst),
    .clk(clk),
    .SignType(ImmType),
    .SignNumber(pipe_instr[31:12]),
    .SignNumber1(pipe_instr[11:7]),
    .out(extendnum)
); 

ALUCtrl aluctrl(
    .rst(rst),
    .clk(clk),
    .ALUOp(ALUOp),
    .Funct7(pipe_instr[31:25]),
    .Funct3(pipe_instr[14:12]),
    .ALUCtrl(OpCtrl),
    .data_type(data_type)
);

ALU alu (
    .rst(rst),
    .clk(clk),
    .ALUCtrl(OpCtrl),
    .r1_data(data1),
    .r2_data(ALUReg),
    .ALUOut(ALUOut),
    .shamt(pipe_instr[24:20]),
    .ZeroFlag(ZeroFlag)
);

BranchCtrl branchctrl (
    .rst(rst),
    .clk(clk),
    .Branch(Branch),
    .Funct3(pipe_instr[14:12]),
    .ZeroFlag(ZeroFlag),
    .ALUResult(ALUOut[0]),
    .Signal(branchCtrl)
       
 );

endmodule
