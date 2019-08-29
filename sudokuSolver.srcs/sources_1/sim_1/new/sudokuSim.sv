`timescale 1ns / 1ps
`define CLOCKTIME 100 //1000ns for 100MHz

 module sudokuSim();
	reg  start_tb = 0;
	bit  clk_tb = 0;
	//reg[323:0] enter_tb;
	//wire[323:0] outputs_tb;
	reg[323:0] enter_reg;
	reg[3:0] enter_tb;
	wire readyToStart_tb;
	wire busy_tb;
	wire done_tb;
	wire[3:0] outputs_tb;
	
	integer yeet = 0, counting = 0;
	
	always #`CLOCKTIME clk_tb <= ~clk_tb;
	
	sudoku_v DUT(.start(start_tb),.clk(clk_tb),.enter(enter_tb),.readyToStart(readyToStart_tb),.done(done_tb),.outputs(outputs_tb));
	
	initial begin
		enter_reg <= {{4'd0,4'd7,4'd6,4'd3,4'd1,4'd4,4'd9,4'd5,4'd8},{4'd8,4'd5,4'd4,4'd9,4'd6,4'd2,4'd7,4'd1,4'd3},{4'd9,4'd1,4'd3,4'd8,4'd7,4'd5,4'd2,4'd6,4'd4},{4'd4,4'd6,4'd8,4'd1,4'd2,4'd7,4'd3,4'd9,4'd5},{4'd5,4'd9,4'd7,4'd4,4'd3,4'd8,4'd6,4'd2,4'd0},{4'd1,4'd3,4'd2,4'd5,4'd9,4'd6,4'd4,4'd8,4'd7},{4'd3,4'd2,4'd5,4'd7,4'd8,4'd9,4'd1,4'd4,4'd6},{4'd6,4'd4,4'd1,4'd2,4'd5,4'd3,4'd8,4'd7,4'd9},{4'd7,4'd8,4'd9,4'd6,4'd4,4'd1,4'd5,4'd3,4'd2}};
		
		// #10ns;
		// start_tb <= 1;
		// #100ns;
		// start_tb <= 0;
		// #20000ns;
		// $finish;
	end
	
	always@(posedge clk_tb) begin
		case(yeet)
			0 : begin
				yeet <= yeet +1;
			end
			1 : begin
				
				yeet <= yeet +1;
			end
			2 : begin
				yeet <= yeet +1;
			end
			3 : begin
				start_tb <= 1;
				yeet <= yeet +1;
			end
			4 : begin
				start_tb <= 0;
				enter_tb <= enter_reg[(323-counting*4)-:4];
				counting <= counting + 1;
				if(counting == 81) begin
					counting <= 0;
					yeet <= yeet +1;
				end
			end
			4 : begin
				if(done_tb )
					yeet <= yeet +1;
			end
			5 : begin
				counting <= counting + 1;
				if(counting == 81)
					yeet <= yeet +1;
			end
			6 : begin
				yeet <= yeet +1;
			end
			7 : begin
				
				yeet <= yeet +1;
			end
			8 : begin
				
				yeet <= yeet +1;
			end
			9 : begin
				
				yeet <= yeet +1;
			end
			10 : begin
				
				yeet <= yeet +1;
			end
			11 : begin
				
				yeet <= yeet +1;
			end
			12 : begin
				
				yeet <= yeet +1;
			end
			13 : begin
				
				yeet <= yeet +1;
			end
			14 : begin
				
				yeet <= yeet +1;
			end
			15 : begin
				
				yeet <= yeet +1;
			end
			16 : begin
				
				yeet <= yeet +1;
			end
			17 : begin
				
				yeet <= yeet +1;
			end
			18 : begin
				
				yeet <= yeet +1;
			end
			19 : begin
				
				yeet <= yeet +1;
			end
			20 : begin
				
				yeet <= yeet +1;
			end
			21 : begin
				
				yeet <= yeet +1;
			end
			22 : begin
				
				yeet <= yeet +1;
			end
			23 : begin
				
				yeet <= yeet +1;
			end
			24 : begin
				
				yeet <= yeet +1;
			end
		endcase
	end
	
endmodule
