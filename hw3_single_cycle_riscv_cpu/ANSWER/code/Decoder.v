module Decoder(
    clk,
    rst,
    opcode,
    ImmType,
    RegWrite,
    PCtoRegSrc,
    Branch,
    ALUSrc,
    ALUOp,
    RDSrc,
    MemRead,
    MemWrite,
    MemtoReg 
);

input       clk;
input       rst;
input  [6:0]opcode;

output reg [2:0] ImmType;
output reg       RegWrite,PCtoRegSrc,ALUSrc,RDSrc,MemRead,MemWrite,MemtoReg;
output reg [2:0] ALUOp;
output reg [1:0] Branch;

always@(*)    begin
    case(opcode)
        (7'b0110011) : // R-type 
            {RegWrite,ImmType,PCtoRegSrc,ALUSrc,Branch,RDSrc,MemRead,MemWrite,MemtoReg,ALUOp} =15'b100001100001010;
        (7'b0000011) : // I-type
            {RegWrite,ImmType,PCtoRegSrc,ALUSrc,Branch,RDSrc,MemRead,MemWrite,MemtoReg,ALUOp} =15'b100000100100000;
        (7'b0010011) : // I-type
            {RegWrite,ImmType,PCtoRegSrc,ALUSrc,Branch,RDSrc,MemRead,MemWrite,MemtoReg,ALUOp} =15'b100000100001110;
        (7'b1100111) : // I-type
            {RegWrite,ImmType,PCtoRegSrc,ALUSrc,Branch,RDSrc,MemRead,MemWrite,MemtoReg,ALUOp} =15'b100000001001000;
        (7'b0100011) : // S-type
            {RegWrite,ImmType,PCtoRegSrc,ALUSrc,Branch,RDSrc,MemRead,MemWrite,MemtoReg,ALUOp} =15'b000100100010000;
        (7'b1100011) : // B-type
            {RegWrite,ImmType,PCtoRegSrc,ALUSrc,Branch,RDSrc,MemRead,MemWrite,MemtoReg,ALUOp} =15'b001001010000001;
        (7'b0010111) : // U-type
            {RegWrite,ImmType,PCtoRegSrc,ALUSrc,Branch,RDSrc,MemRead,MemWrite,MemtoReg,ALUOp} =15'b101110101001011;
        (7'b0110111) : // U-type
            {RegWrite,ImmType,PCtoRegSrc,ALUSrc,Branch,RDSrc,MemRead,MemWrite,MemtoReg,ALUOp} =15'b101100100001011;
        (7'b1101111) : // J-type
            {RegWrite,ImmType,PCtoRegSrc,ALUSrc,Branch,RDSrc,MemRead,MemWrite,MemtoReg,ALUOp} =15'b110000111001000;
        default: begin
            {RegWrite,ImmType,PCtoRegSrc,ALUSrc,RDSrc,MemRead,MemWrite,MemtoReg,ALUOp} = 13'b0;
            Branch = 2'b10;
        end
    endcase  
end

endmodule 
