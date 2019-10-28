`timescale 1ns / 1ps
module sudoku_v(//start,clk,enter,readyToStart,done,out);
	input start,
	input clk,
	input[3:0] enter,
	//input[323:0] enter,
	output reg readyToStart = 0,
	output reg done = 0,
	output reg borked = 0,
	//output reg[323:0] outputs);
	output reg[3:0] outputs = 4'b0000);
	
	reg [323:0] working;
	reg [80:0]	finals;
	reg backtrack = 0;
	reg [3:0] x = 4'd0, y = 4'd0;
	integer MC = 0;
	integer f,a,b,r,s,inOutCount = 32'd0;
	parameter ready = 4'd0, load = 4'd1, tasks = 4'd2, finish = 4'd3;
	
	always @(posedge clk) begin
		case(MC)
			ready: begin
				x <= 4'd0;
				y <= 4'd0;
				outputs <= 4'b0000;
				done <= 0;
				readyToStart <= 1;
				backtrack <= 0;
				inOutCount <= 32'd0;
				borked <= 0;
				finals <= 81'd0;
				if(start == 1) begin
					MC <= load;
					readyToStart <= 0;
				end
			end
			
			load: begin
				if(x == 4'd8) begin
					y <= y + 1'd1;
					x <= 4'd0;
				end
				else
					x <= x + 1'd1;
					
				if(enter != 4'b0000)
					finals[80-(y*9+x)] <= 1;
				else
					finals[80-(y*9+x)] <= 0;
				working[323-4*(y*9+x)-:4] <= enter;
				inOutCount <= inOutCount + 1'd1;
				
				if(inOutCount == 32'd81) begin
					x <= 4'd0;
					y <= 4'd0;
					MC <= tasks;
					inOutCount <= 32'd0;
				end
			end
			
			tasks: begin
				if(finals[80-(y*9+x)] == 0) begin
					if(working[323-4*(y*9+x)-:4] == 4'd8) begin
						backtrack <= 1;
						working[323-4*(y*9+x)-:4] <= 4'd0;
						if(x == 4'd0 && y == 4'd0) begin
							//if it gets here, shit is fucked. cannot be solved
							borked <= 1;
							MC <= ready;
						end
						else if(x == 4'd0) begin
							y <= y - 1'd1;
							x <= 4'd8;
						end
						else 
							x <= x - 1'd1;
					end
					else begin
						working[323-4*(y*9+x)-:4] <= working[323-4*(y*9+x)-:4] + 1'd1;
						backtrack <= 0;
						if(colChecker(working[323-4*(y*9+x)-:4]) == 1) begin
							if(rowChecker(working[323-4*(y*9+x)-:4]) == 1) begin
								//if(squareChecker(working[323-4*(y*9+x)-:4]) == 1) begin
									if(x == 4'd8 && y == 4'd8) begin
										x <= 4'd0;
										y <= 4'd0;
										MC <= finish;
									end
									else if(x == 4'd8) begin
										y <= y + 1'd1;
										x <= 4'd0;
									end
									else
										x <= x + 1'd1;
								//end
							end
						end
					end
				end
				else if (backtrack == 1) begin
					if(x == 4'd0 && y == 4'd0) begin
						//if it gets here, shit is fucked. cannot be solved
						borked <= 1;
						MC <= ready;
					end
					else if(x == 4'd0) begin
						y <= y - 1'd1;
						x <= 4'd8;
					end
					else 
						x <= x - 1'd1;
				end
				else begin
					backtrack <= 0;
					if(x == 4'd8 && y == 4'd8) begin
						x <= 4'd0;
						y <= 4'd0;
						MC <= finish;
					end
					else if(x == 4'd8) begin
						y <= y + 1'd1;
						x <= 4'd0;
					end
					else
						x <= x + 1'd1;
				end
			end
			
			finish: begin
				if(x == 4'd8) begin
					y <= y + 1'd1;
					x <= 4'd0;
				end
				else
					x <= x + 1'd1;
				
				outputs <= working[323-4*(y*9+x)-:4];
				inOutCount <= inOutCount + 1'd1;
				
				if(inOutCount == 32'd81) begin
					MC <= ready;
					done <= 0;
					inOutCount <= 0;
				end
			end
		endcase
	end
	
	//Assigns outputs
//	genvar igloo,hi;
//	generate
//		for(igloo = 0; igloo < 9; igloo = igloo + 1) begin : row1
//			for(hi = 0; hi < 9; hi = hi + 1) begin : column1
//				always@(clk) begin
//					outputs[323-4*(igloo*9+hi)-:4] <= findFinal(hi,igloo);
//				end
//			end
//		end
//	endgenerate
	
	//rowchecker function
	function[0:0] rowChecker;								//COUNTS HOW MANY TIMES A NUMBER SHOWS UP IN A ROW. CHANGED THE checkMeS AND checkMeS
		input[3:0] checkMe;
		reg[3:0] rowCount;
		begin
			rowCount = 4'd0;
			if(working[323-4*(y*9+0)-:4] == checkMe)
				rowCount = rowCount + 1'd1;
			if(working[323-4*(y*9+1)-:4] == checkMe)
				rowCount = rowCount + 1'd1;
			if(working[323-4*(y*9+2)-:4] == checkMe)
				rowCount = rowCount + 1'd1;
			if(working[323-4*(y*9+3)-:4] == checkMe)
				rowCount = rowCount + 1'd1;
			if(working[323-4*(y*9+4)-:4] == checkMe)
				rowCount = rowCount + 1'd1;
			if(working[323-4*(y*9+5)-:4] == checkMe)
				rowCount = rowCount + 1'd1;
			if(working[323-4*(y*9+6)-:4] == checkMe)
				rowCount = rowCount + 1'd1;
			if(working[323-4*(y*9+7)-:4] == checkMe)
				rowCount = rowCount + 1'd1;
			if(working[323-4*(y*9+8)-:4] == checkMe)
				rowCount = rowCount + 1'd1;
			
			if(rowCount > 4'd1)
				rowChecker = 0;
			else 
				rowChecker = 1;
		end 
	endfunction
	
	//colchecker function
	function[0:0] colChecker;
		input[3:0] checkMee;
		reg[3:0] colCount;
		begin
			colCount = 4'd0;
			if(working[323-4*(0*9+x)-:4] == checkMee)
				colCount = colCount + 1'd1;
			if(working[323-4*(1*9+x)-:4] == checkMee)
				colCount = colCount + 1'd1;
			if(working[323-4*(2*9+x)-:4] == checkMee)
				colCount = colCount + 1'd1;
			if(working[323-4*(3*9+x)-:4] == checkMee)
				colCount = colCount + 1'd1;
			if(working[323-4*(4*9+x)-:4] == checkMee)
				colCount = colCount + 1'd1;
			if(working[323-4*(5*9+x)-:4] == checkMee)
				colCount = colCount + 1'd1;
			if(working[323-4*(6*9+x)-:4] == checkMee)
				colCount = colCount + 1'd1;
			if(working[323-4*(7*9+x)-:4] == checkMee)
				colCount = colCount + 1'd1;
			if(working[323-4*(8*9+x)-:4] == checkMee)
				colCount = colCount + 1'd1;
			
			if(colCount > 4'd1)
				colChecker = 0;
			else 
				colChecker = 1;
		end 
	endfunction
	
	// squarechecker function
	function[0:0] squareChecker;
		input[3:0] checkMeee;
		reg[3:0] squareCount;
		integer a,b;
		begin
			if(x <= 4'd2)
				a = 0;
			else if(x <= 4'd5)
				a = 1;
			else //if(x <= 4'd8)
				a = 2;
				
			if(y <= 4'd2)
				b = 0;
			else if(y <= 4'd5)
				b = 1;
			else //if(y <= 4'd8)
				b = 2;
			
			if(x != 3*a) begin
				if(y != 3*b) begin
					if(working[323-4*((3*b)*9+(3*a))-:4] == checkMeee)
						squareCount = squareCount + 1'd1;
				end
			end
			if(x != 3*a+1) begin
				if(y != 3*b+1) begin
					if(working[323-4*((3*b+1)*9+(3*a+1))-:4] == checkMeee)
						squareCount = squareCount + 1'd1;
				end
			end
			if(x != 3*a+2) begin
				if(y != 3*b+2) begin
					if(working[323-4*((3*b+2)*9+(3*a+2))-:4] == checkMeee)
						squareCount = squareCount + 1'd1;
				end
			end
			
			if(squareCount > 4'd1)
				squareChecker = 0;
			else
				squareChecker = 1;
		end
	endfunction
endmodule 
