module ALUCtrl (
    rst,
    clk,
    ALUOp,
    Funct3,
    Funct7,
    ALUCtrl,
    data_type
);


input rst;
input clk;

input [2:0] ALUOp;
input [2:0] Funct3;
input [6:0] Funct7;

output reg [3:0] ALUCtrl;
output reg [2:0] data_type;

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
          IMM =4'b1101,
          BGE = 4'b1110,
          BGEU = 4'b1111;
parameter BYTE=3'b000,
          HWORD=3'b001,
          BYTE_U=3'b010,
          HWORD_U=3'b011,
          WORD = 3'b100;
always@(*) begin    
    data_type = WORD;
    ALUCtrl = ADD;
    case (ALUOp)
        3'b000: begin
            ALUCtrl = ADD;
            case(Funct3) 
                3'b000:data_type=BYTE;
                3'b001:data_type=HWORD;
                3'b100:data_type=BYTE_U;
                3'b101:data_type=HWORD_U;
                default:data_type=WORD;
            endcase
        end
        3'b010:
            case(Funct3) 
                3'b000:
                    ALUCtrl = (Funct7 == 7'b0)? ADD : SUB;
                3'b001:
                    ALUCtrl = SLL ;
                3'b010:
                    ALUCtrl = SLT;
                3'b011:
                    ALUCtrl = SLTU;
                3'b100:
                    ALUCtrl = XOR;
                3'b101:
                    ALUCtrl = (Funct7 == 7'b0)?SRL : SRA;
                3'b110:
                    ALUCtrl = OR;
                3'b111:
                    ALUCtrl = AND;
            endcase
        3'b001:
            case(Funct3)
                3'b000:
                    ALUCtrl = SUB;
                3'b001:
                    ALUCtrl = SUB;
                3'b100:
                    ALUCtrl = SLT;
                3'b101: 
                    ALUCtrl = BGE; 
                3'b110:
                    ALUCtrl = SLTU;
                3'b111:
                    ALUCtrl = BGEU;
                default:
                    ALUCtrl = SUB;
            endcase 
        3'b011:
            ALUCtrl = IMM;
        3'b110:
            case(Funct3) 
                3'b000:
                    ALUCtrl = ADD ;
                3'b001:
                    ALUCtrl = SLLI;
                3'b010:
                    ALUCtrl = SLT;
                3'b011:
                    ALUCtrl = SLTU;
                3'b100:
                    ALUCtrl = XOR;
                3'b101:
                    ALUCtrl = (Funct7 == 7'b0)? SRLI : SRAI;
                3'b110:
                    ALUCtrl = OR;
                3'b111:
                    ALUCtrl = AND;
            endcase
    endcase
end 

endmodule
