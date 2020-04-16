module Register (
    clk,
    rst,
    rs1,
    rs2,
    rd,
    r_data1,
    r_data2,
    w_data,
    w_signal 
);

input       clk;
input       rst;
input [4:0] rs1;
input [4:0] rs2;
input [4:0] rd ;
input [31:0] w_data;
input w_signal;

output [31:0] r_data1;
output [31:0] r_data2;

reg [31:0] register [31:0];

integer i;

assign r_data1 = register[rs1];
assign r_data2 = register[rs2];

always@ (posedge clk) begin
    if(rst)
        for(i=0;i<32;i=i+1)
            register[i] <= 32'b0;
    else
        if(w_signal) begin
          register[rd] <= (rd==0)? 0: w_data;      
        end
end


endmodule
