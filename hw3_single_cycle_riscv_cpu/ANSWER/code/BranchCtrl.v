module BranchCtrl (
    clk,
    rst,
    Branch,
    Funct3,
    ZeroFlag,
    ALUResult,
    Signal,
);

input clk;
input rst;
input [1:0] Branch;
input [2:0] Funct3;
input ZeroFlag;
input ALUResult;

output reg [1:0] Signal ;

always@(*) begin    
    case(Branch)
        2'b00:
            Signal = 2'b00;
        2'b01:
            case(Funct3)
                3'b000:
                    Signal = (ZeroFlag)?2'b01:2'b10;
                3'b001:
                    Signal = (ZeroFlag)?2'b10:2'b01;
                3'b100:
                    Signal = (ALUResult) ?2'b01:2'b10;
                3'b101:
                    Signal = (ALUResult)? 2'b01:2'b10;
                3'b110:
                    Signal = (ALUResult)? 2'b01:2'b10;
                3'b111: 
                    Signal = (ALUResult)? 2'b01:2'b10; 
                default:
                    Signal = 2'b00;
            endcase
        2'b10:
            Signal = 2'b10;
        2'b11:
            Signal = 2'b01;
    endcase
end

endmodule
