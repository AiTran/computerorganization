module traffic_light (
    input  clk,
    input  rst,
    input  pass,
    output R,
    output G,
    output Y
);

//write your code here
/* 02/17/2020
	Author: Ai
	Version 1 */
	
	reg [3:0]	state;
	reg [3:0]	next_state;
	reg [9:0]	counter;
	reg  		check;
	
	parameter green_light1	= 3'b010;
	parameter green_light2	= 3'b011;
	parameter green_light3	= 3'b111;
	parameter idle1			= 3'b101;
	parameter idle2			= 3'b110;
	parameter yellow_light	= 3'b001;
	parameter red_light		= 3'b100;
	
	assign G = (state == (green_light1) | state == green_light2 | state == green_light3);
	assign R = (state == red_light);
	assign Y = (state == yellow_light);
	
	always @ (posedge clk, posedge rst) // to update state
		begin
			if(rst)
				begin
					state <= green_light1;
					counter <= 10'b0;
					check = 1'b0;
				end
			else
				begin
					state <= (pass)? green_light1 : next_state;
					counter <= (check |(pass & (next_state != green_light1))) ? 10'b0 : counter + 10'b1;
				end
		end
	
	always @(*) begin
		next_state = state;
		case(state)
			green_light1: begin
				if (counter == 10'd1023) //1024
				begin
					/* counter = 10'b0; */
					next_state = idle1;
					check = 1'b1;
					
				end
				else
				begin
					check = 1'b0;
					next_state = green_light1;
					//counter <= counter + 10'b1;
				end
			end
			idle1: begin
				if (counter == 10'd127) //1152
				begin
					//counter = 10'b0;
					next_state = green_light2;
					check = 1'b1;
				end
				else
				begin
					check = 1'b0;
					next_state = idle1;
					//counter <= counter + 10'b1;
				end
			end
			green_light2: begin
				if (counter == 10'd127) //1280
				begin
					
					//counter = 10'b0;
					next_state = idle2;
					check = 1'b1;
					//counter = 10'b0;
				end
				else
				begin
					check = 1'b0;
					next_state = green_light2;
					//counter <= counter + 10'b1;
				end
			end
			idle2 : begin
				if (counter == 10'd127)
				begin
					check = 1'b1;
					//counter = 10'b0;
					next_state = green_light3;
				end
				else
				begin
					check = 1'b0;
					next_state = idle2;
					//counter <= counter + 10'b1;
				end
			end
			green_light3: begin
				if (counter == 10'd127)
				begin
					check = 1'b1;
					next_state = yellow_light;
					//counter = 10'b0;
				end
				else
				begin
					check = 1'b0;
					next_state = green_light3;
					//counter <= counter + 10'b1;
				end
			end
			yellow_light : begin
				if (counter == 10'd511)
				begin
					check = 1'b1;
					next_state = red_light;
					//counter = 10'b0;
				end
				else
				begin
					check = 1'b0;
					next_state = yellow_light;
					//counter <= counter + 10'b1;
				end
			end
			red_light : begin
				if (counter == 10'd1023)
				begin
					check = 1'b1;
					next_state = green_light1;
				end
				else
				begin
					check = 1'b0;
					next_state = red_light;
				end
			end
		endcase
	end
	
endmodule
