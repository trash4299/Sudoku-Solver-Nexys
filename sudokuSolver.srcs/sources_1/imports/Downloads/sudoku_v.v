`timescale 1ns / 1ps
module sudoku_v(start,clk,enter,readyToStart,done,out);
	input start;
	input clk;
	input[323:0] enter;
	output reg readyToStart;
	output reg done;
	output reg[323:0] out;
	
	reg [728:0] maybes;
	integer MC,x,y,ex,why,i,k,n,h,g;
	integer f,a,b,r,s,differenc,counte;
	parameter ready = 4'd0, load = 4'd1, tasks = 4'd2, finish = 4'd3;
	
	initial begin
		MC <= 0;
	end
	
	always @(posedge clk) begin
		case(MC)
			ready: begin
				done <= 0;
				readyToStart <= 1;
				if(start == 1)
					MC <= load;
			end
			
			load: begin 
				readyToStart <= 0;
				x <= 0;
				y <= 0;
				//requires the numbers to be imported as 4-bit numbers, reading left to right and top down
				for(i = 0; i < 9; i = i + 1) begin : row //i == y k ==x
					for(k = 0; k < 9; k = k + 1) begin : column
						case(enter[323-4*(i*9+k)-:4])
							4'd0: maybes[728-9*(i*9+k)-:9] <= 9'b111111111;
							4'd1: maybes[728-9*(i*9+k)-:9] <= 9'b000000001;
							4'd2: maybes[728-9*(i*9+k)-:9] <= 9'b000000010;
							4'd3: maybes[728-9*(i*9+k)-:9] <= 9'b000000100;
							4'd4: maybes[728-9*(i*9+k)-:9] <= 9'b000001000;
							4'd5: maybes[728-9*(i*9+k)-:9] <= 9'b000010000;
							4'd6: maybes[728-9*(i*9+k)-:9] <= 9'b000100000;
							4'd7: maybes[728-9*(i*9+k)-:9] <= 9'b001000000;
							4'd8: maybes[728-9*(i*9+k)-:9] <= 9'b010000000;
							4'd9: maybes[728-9*(i*9+k)-:9] <= 9'b100000000;
						endcase
					end
				end
				MC <= tasks;
			end
			
			tasks: begin
				//all checking tasks
				$display("tasks");
				for(x = 0;x < 9;x = x + 1) begin
				#15;
					for(y = 0;y < 9; y = y + 1) begin
					#1;
						if(findFinal(x,y) == 0) begin
							colChecker();
							rowChecker();
							$display("rowchecked");
							vertEightNine();
							horiEightNine();
							squareChecker();
						end
					end
				end
				n <= 0; //THIS SECTION IS NOT WORKING RIGHT NOW
				for(h = 0; h < 9; h = h + 1) begin
					for(g = 0; g < 9; g = g + 1) begin
						if(findFinal(h,g) != 4'b0)
							n <= n + 1;
					end
				end
				if (n == 81)
					MC <= finish;
//				else begin
//					MC <= tasks;
//				end
			end
			
			finish: begin
				//assign outputs
				done <= 1;
				MC <= ready;
			end
			
		endcase
	end
	
	//functions and tasks
	
	function [3:0] findFinal; //returns 0 is the cell is not final
		input [3:0] ex;
		input [3:0] why;
		
		case(maybes[728-9*(why*9+ex)-:9])
			9'b000000001: findFinal = 4'd1;
			9'b000000010: findFinal = 4'd2;
			9'b000000100: findFinal = 4'd3;
			9'b000001000: findFinal = 4'd4;
			9'b000010000: findFinal = 4'd5;
			9'b000100000: findFinal = 4'd6;
			9'b001000000: findFinal = 4'd7;
			9'b010000000: findFinal = 4'd8;
			9'b100000000: findFinal = 4'd9;
			default: findFinal = 4'd0;
		endcase
	endfunction
	
	
	genvar igloo,hi;
	generate
		for(igloo = 0; igloo < 9; igloo = igloo + 1) begin : row1
			for(hi = 0; hi < 9; hi = hi + 1) begin : column1
				always@(clk) begin
					out[323-4*(igloo*9+hi)-:4] <= findFinal(hi,igloo);
				end
			end
		end
	endgenerate
	
	//rowchecker task
	task rowChecker;
		for(f = 0; f < 9; f = f + 1) begin
			if(f != y) begin
				case(findFinal(x,f))
//					4'd0 break;	//does nothing if returns 0 because it is not final
//					4'd1: maybes[x][y][0] <= 0;
//					4'd2: maybes[x][y][1] <= 0;
//					4'd3: maybes[x][y][2] <= 0;
//					4'd4: maybes[x][y][3] <= 0;
//					4'd5: maybes[x][y][4] <= 0;
//					4'd6: maybes[x][y][5] <= 0;
//					4'd7: maybes[x][y][6] <= 0;
//					4'd8: maybes[x][y][7] <= 0;
//					4'd9: maybes[x][y][8] <= 0;
					4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
					4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
					4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
					4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
					4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
					4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
					4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
					4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
					4'd9: maybes[728-9*(y*9+x)-:1]   <= 0;
				endcase
			end
		end
	endtask
	
	//colchecker task
	task colChecker;
		for(f = 0; f < 9; f = f + 1) begin
			if(f != x) begin
				case(findFinal(f,y))
//					4'd0: break;	//does nothing if returns 0 because it is not final
					4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
					4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
					4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
					4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
					4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
					4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
					4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
					4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
					4'd9: maybes[728-9*(y*9+x)-:1]   <= 0;
				endcase
			end
		end
	endtask
	
	
	
	//squarechecker task
	task squareChecker; begin
		a = x/3;
		b = y/3;
		for(r = (3*a);r < (3*a+3); r = r + 1) begin
			for(s = (3*b);s < (3*b+3); s = s + 1) begin
				if(x!=r && y!=s) begin
					case(findFinal(r,s))
//						4'd0: break;	//does nothing if returns 0 because it is not final
						4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
						4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
						4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
						4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
						4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
						4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
						4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
						4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
						4'd9: maybes[728-9*(y*9+x)-:1]   <= 0;
					endcase
				end
			end
		end
	end
	endtask
	
	
	
	//rowpossibilities ??
	//colpossibilities ??
	
	
	//horiEightNine
	task horiEightNine;
	begin
		counte <= 0;
		differenc <= 0;
		for(r = 0; r < 9; r = r + 1) begin
			if(findFinal(r,y)!=0) begin
				counte <= counte + 1;
				differenc <= differenc + findFinal(r,y);
			end
		end
		if(counte == 8) begin
			for(r = 0; r < 9; r = r + 1) begin
				if(findFinal(r,y) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(y*9+r)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(y*9+r)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(y*9+r)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(y*9+r)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(y*9+r)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(y*9+r)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(y*9+r)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(y*9+r)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(y*9+r)-:9] <= 9'b100000000;
					endcase
				end
			end
		end
	end
	endtask
	
	//vertEightNine 
	task vertEightNine;
	begin
		counte <= 0;
		differenc <= 0;
		for(r = 0; r < 9; r = r + 1) begin
			if(findFinal(x,r)!=0) begin
				counte <= counte + 1;
				differenc <= differenc + findFinal(x,r);
			end
		end
		if(counte == 8) begin
			for(r = 0; r < 9; r = r + 1) begin
				if(findFinal(x,r) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(r*9+x)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(r*9+x)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(r*9+x)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(r*9+x)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(r*9+x)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(r*9+x)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(r*9+x)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(r*9+x)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(r*9+x)-:9] <= 9'b100000000;
					endcase
				end
			end
		end
	end
	endtask
	
endmodule 
