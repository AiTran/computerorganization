module SignExtend(
    rst,
    clk,
    SignType,
    SignNumber,
    SignNumber1,
    out
);

input rst;
input clk;
input [2:0]  SignType;
input [19:0] SignNumber;
input [4:0]  SignNumber1;

output reg[31:0] out ;

always @(*) begin
    case(SignType)
        3'b000://I-type
            out = {{20{SignNumber[19]}},SignNumber[19:8]};
        3'b001://S-type
            out = {{20{SignNumber[19]}},SignNumber[19:13],SignNumber1[4:0]};
        3'b010://B-type
            out = {{19{SignNumber[19]}},SignNumber[19],SignNumber1[0],SignNumber[18:13],SignNumber1[4:1],1'b0};
        3'b011://U-type
            out = {SignNumber[19:0],12'b0};
        3'b100://J-type
            out = {{11{SignNumber[19]}},SignNumber[19],SignNumber[7:0],SignNumber[8],SignNumber[18:9],1'b0};
        default:
            out = 32'b0;
    endcase
end

endmodule
