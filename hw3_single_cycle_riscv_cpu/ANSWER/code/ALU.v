module ALU(
    clk,
    rst,
    r1_data,
    r2_data,
    ALUCtrl,
    ZeroFlag,
    shamt,
    ALUOut
);

input clk;
input rst;
input [31:0] r1_data;
input [31:0] r2_data;
input [3:0]ALUCtrl;
input [4:0] shamt;

output  ZeroFlag;
output reg[31:0] ALUOut;


wire signed [31:0] SignData1;
wire signed [31:0] SignData2;

assign SignData1 = r1_data;
assign SignData2 = r2_data;

assign ZeroFlag = ~|(ALUOut);

parameter ADD = 4'b0000,
          SUB = 4'b0001,
          SLL = 4'b0010,
          SLT = 4'b0011,
          SLTU = 4'b0100,
          XOR = 4'b0101,
          SRL = 4'b0110,
          SRA = 4'b0111,
          OR = 4'b1000,
          AND = 4'b1001,
          SLLI = 4'b1010,
          SRLI = 4'b1011,
          SRAI =4'b1100,
          IMM = 4'b1101,
          BGE = 4'b1110,
          BGEU = 4'b1111;

always@(*) begin
    case (ALUCtrl)
        AND:
            ALUOut = r1_data & r2_data;
        OR : 
            ALUOut = r1_data | r2_data;
        XOR :
            ALUOut = r1_data ^ r2_data;
        ADD :
            ALUOut = r1_data + r2_data ;
        SUB :
            ALUOut = r1_data + (~r2_data) + 1'b1;
        SLL : 
            ALUOut = r1_data << r2_data[4:0];
        SLLI :
            ALUOut = r1_data << shamt ;
        SLT :
            ALUOut = (SignData1 < SignData2)? 32'b1:32'b0;
        SLTU :
            ALUOut = (r1_data < r2_data )? 32'b1 : 32'b0;
        SRL : 
            ALUOut = r1_data >> r2_data[4:0];
        SRA :
            ALUOut = SignData1 >>> r2_data[4:0];
        SRLI :
            ALUOut = r1_data >> shamt;
        SRAI : 
            ALUOut = SignData1 >>> shamt;
        IMM  :
            ALUOut = r2_data ;
        BGE :
            ALUOut =(SignData1 < SignData2)? 32'b0:32'b1;
        BGEU :
            ALUOut = (r1_data  < r2_data)? 32'b0:32'b1;
        default:
            ALUOut = 32'b0;
    endcase
end

endmodule 
