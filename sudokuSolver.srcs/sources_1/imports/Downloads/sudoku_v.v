`timescale 1ns / 1ps
module sudoku_v(//start,clk,enter,readyToStart,done,out);
	input start,
	input clk,
	input[3:0] enter,
	//input[323:0] enter,
	output reg readyToStart = 0,
	output reg done = 0,
	//output reg[323:0] outputs);
	output reg[3:0] outputs = 4'b0000);
	
	reg [728:0] maybes;
	integer MC = 0,x = 0,y = 0,i,k,n,h,g;
	integer f,r,s,inOutCount = 0;
	parameter ready = 4'd0, load = 4'd1, tasks = 4'd2, donzo = 4'd3, finish = 4'd4;
	
	always @(posedge clk) begin
		case(MC)
			ready: begin
				x <= 0;
				y <= 0;
				outputs <= 4'b0000;
				done <= 0;
				readyToStart <= 1;
				if(start == 1) begin
					MC <= load;
					readyToStart <= 0;
				end
			end
			
			load: begin
				if(x == 8) begin
					y <= y + 1;
					x <= 0;
				end
				else
					x <= x + 1;
				
				case(enter)
					4'd0: maybes[728-9*(y*9+x)-:9] <= 9'b111111111;
					4'd1: maybes[728-9*(y*9+x)-:9] <= 9'b000000001;
					4'd2: maybes[728-9*(y*9+x)-:9] <= 9'b000000010;
					4'd3: maybes[728-9*(y*9+x)-:9] <= 9'b000000100;
					4'd4: maybes[728-9*(y*9+x)-:9] <= 9'b000001000;
					4'd5: maybes[728-9*(y*9+x)-:9] <= 9'b000010000;
					4'd6: maybes[728-9*(y*9+x)-:9] <= 9'b000100000;
					4'd7: maybes[728-9*(y*9+x)-:9] <= 9'b001000000;
					4'd8: maybes[728-9*(y*9+x)-:9] <= 9'b010000000;
					4'd9: maybes[728-9*(y*9+x)-:9] <= 9'b100000000;
				endcase
				inOutCount <= inOutCount + 1;
				
				if(inOutCount == 81) begin
					x <= 0;
					y <= 0;
					MC <= tasks;
					inOutCount <= 0;
				end
				
				
				// readyToStart <= 0;
				// x <= 0;
				// y <= 0;
				// requires the numbers to be imported as 4-bit numbers, reading left to right and top down
				// for(i = 0; i < 9; i = i + 1) begin : row //i == y k ==x
					// for(k = 0; k < 9; k = k + 1) begin : column
						// case(enter[323-4*(i*9+k)-:4])
							// 4'd0: maybes[728-9*(i*9+k)-:9] <= 9'b111111111;
							// 4'd1: maybes[728-9*(i*9+k)-:9] <= 9'b000000001;
							// 4'd2: maybes[728-9*(i*9+k)-:9] <= 9'b000000010;
							// 4'd3: maybes[728-9*(i*9+k)-:9] <= 9'b000000100;
							// 4'd4: maybes[728-9*(i*9+k)-:9] <= 9'b000001000;
							// 4'd5: maybes[728-9*(i*9+k)-:9] <= 9'b000010000;
							// 4'd6: maybes[728-9*(i*9+k)-:9] <= 9'b000100000;
							// 4'd7: maybes[728-9*(i*9+k)-:9] <= 9'b001000000;
							// 4'd8: maybes[728-9*(i*9+k)-:9] <= 9'b010000000;
							// 4'd9: maybes[728-9*(i*9+k)-:9] <= 9'b100000000;
						// endcase
					// end
				// end
				// MC <= tasks;
			end
			
			tasks: begin
				//checking tasks
				if(findFinal(x,y) == 0) begin
					colChecker();
					rowChecker();
					vertEightNine();
					horiEightNine();
					//squareChecker();
				end
				if(x == 8 && y == 8) begin
					x <= 0;
					y <= 0;
					n <= 0;
					MC <= donzo;
				end
				else if(x == 8) begin
					y <= y + 1;
					x <= 0;
				end
				else
					x <= x + 1;
			end
			
			donzo: begin
				if(x == 8) begin
					y <= y + 1;
					x <= 0;
				end
				else
					x <= x + 1;
				
				if(findFinal(x,y) != 4'b0)
					n = n + 1;
				
				if(x == 8 && y == 8) begin
					x <= 0;
					y <= 0;
					if(n == 81) begin
						MC <= finish;
						done <= 1;
					end
					else
						MC <= tasks;
				end
			end
			
			finish: begin
				if(x == 8) begin
					y <= y + 1;
					x <= 0;
				end
				else
					x <= x + 1;
				
				outputs <= findFinal(x,y);
				inOutCount <= inOutCount + 1;
				
				if(inOutCount == 81) begin
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
	
	//functions and tasks
	
	
	//rowpossibilities ??
	//colpossibilities ??
	
	//findFinal NEEDS MAJOR RECONSTRUCTION TO REDUCE LUT COUNT
	function automatic [3:0] findFinal; //returns 0 is the cell is not final
		input [3:0] ex;
		input [3:0] why;
		begin
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
		end
	endfunction
	
	//rowchecker task
	task automatic rowChecker; begin
		if(y != 0) begin
			case(findFinal(x,4'd0))
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
		if(y != 4'd1) begin
			case(findFinal(x,4'd1))
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
		if(y != 4'd2) begin
			case(findFinal(x,4'd2))
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
		if(y != 4'd3) begin
			case(findFinal(x,4'd3))
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
		if(y != 4'd4) begin
			case(findFinal(x,4'd4))
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
		if(y != 4'd5) begin
			case(findFinal(x,4'd5))
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
		if(y != 4'd6) begin
			case(findFinal(x,4'd6))
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
		if(y != 4'd7) begin
			case(findFinal(x,4'd7))
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
		if(y != 4'd8) begin
			case(findFinal(x,4'd8))
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
	task automatic colChecker; begin
		if(x != 4'd0) begin
			case(findFinal(4'd0,y))
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
		if(x != 4'd1) begin
			case(findFinal(4'd1,y))
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
		if(x != 4'd2) begin
			case(findFinal(4'd2,y))
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
		if(x != 4'd3) begin
			case(findFinal(4'd3,y))
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
		if(x != 4'd4) begin
			case(findFinal(4'd4,y))
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
		if(x != 4'd5) begin
			case(findFinal(4'd5,y))
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
		if(x != 4'd6) begin
			case(findFinal(4'd6,y))
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
		if(x != 4'd7) begin
			case(findFinal(4'd7,y))
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
		if(x != 4'd8) begin
			case(findFinal(4'd8,y))
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
	task automatic squareChecker;
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
				case(findFinal((3*a),(3*b)))
					4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
					4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
					4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
					4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
					4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
					4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
					4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
					4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
					4'd9: maybes[728-9*(y*9+x)  -:1] <= 0;
				endcase
			end
		end
		if(x != 3*a+3'd1) begin
			if(y != 3*b+3'd1) begin
				case(findFinal((3*a+3'd1),(3*b+3'd1)))
					4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
					4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
					4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
					4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
					4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
					4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
					4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
					4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
					4'd9: maybes[728-9*(y*9+x)  -:1] <= 0;
				endcase
			end
		end
		if(x != 3*a+3'd2) begin
			if(y != 3*b+3'd2) begin
				case(findFinal((3*a+3'd2),(3*b+3'd2)))
					4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
					4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
					4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
					4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
					4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
					4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
					4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
					4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
					4'd9: maybes[728-9*(y*9+x)  -:1] <= 0;
				endcase
			end
		end
		
		// for(r=(3*a);r<(3*a+3);r=r+1) begin
			// for(s=(3*b);s<(3*b+3);s=s+1) begin
				// if(x!=r) begin
					// if(y!=s) begin
						// case(findFinal(r,s))
							// //4'd0: break;	//does nothing if returns 0 because it is not final
							// 4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
							// 4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
							// 4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
							// 4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
							// 4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
							// 4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
							// 4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
							// 4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
							// 4'd9: maybes[728-9*(y*9+x)  -:1] <= 0;
						// endcase
					// end
				// end
			// end
		// end
	end
	endtask
	
	// task squareChecker; begin
		// if(x <= 2) begin
			// if(y <= 2) begin
				// for(r=0;r<3;r=r+1) begin
					// for(s=0;s<3;s=s+1) begin
						// if(x!=r && y!=s) begin
							// case(findFinal(r,s))
								// 4'd0: break;	//does nothing if returns 0 because it is not final
								// 4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
								// 4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
								// 4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
								// 4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
								// 4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
								// 4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
								// 4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
								// 4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
								// 4'd9: maybes[728-9*(y*9+x)  -:1] <= 0;
							// endcase
						// end
					// end
				// end
			// end
			// else if(y <= 5) begin
				// for(r=0;r<3;r=r+1) begin
					// for(s=3;s<6;s=s+1) begin
						// if(x!=r && y!=s) begin
							// case(findFinal(r,s))
								// 4'd0: break;	//does nothing if returns 0 because it is not final
								// 4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
								// 4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
								// 4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
								// 4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
								// 4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
								// 4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
								// 4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
								// 4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
								// 4'd9: maybes[728-9*(y*9+x)  -:1] <= 0;
							// endcase
						// end
					// end
				// end
				
			// end
			// else begin
				// for(r=0;r<3;r=r+1) begin
					// for(s=6;s<9;s=s+1) begin
						// if(x!=r && y!=s) begin
							// case(findFinal(r,s))
								// 4'd0: break;	//does nothing if returns 0 because it is not final
								// 4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
								// 4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
								// 4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
								// 4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
								// 4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
								// 4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
								// 4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
								// 4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
								// 4'd9: maybes[728-9*(y*9+x)  -:1] <= 0;
							// endcase
						// end
					// end
				// end
				
			// end
		// end
		// else if(x <= 5) begin
			// if(y <= 2) begin
				// for(r=3;r<6;r=r+1) begin
					// for(s=0;s<3;s=s+1) begin
						// if(x!=r && y!=s) begin
							// case(findFinal(r,s))
								// 4'd0: break;	//does nothing if returns 0 because it is not final
								// 4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
								// 4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
								// 4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
								// 4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
								// 4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
								// 4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
								// 4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
								// 4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
								// 4'd9: maybes[728-9*(y*9+x)  -:1]   <= 0;
							// endcase
						// end
					// end
				// end
				
			// end
			// else if(y <= 5) begin
				// for(r=3;r<6;r=r+1) begin
					// for(s=3;s<6;s=s+1) begin
						// if(x!=r && y!=s) begin
							// case(findFinal(r,s))
								// 4'd0: break;	//does nothing if returns 0 because it is not final
								// 4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
								// 4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
								// 4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
								// 4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
								// 4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
								// 4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
								// 4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
								// 4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
								// 4'd9: maybes[728-9*(y*9+x)  -:1] <= 0;
							// endcase
						// end
					// end
				// end
				
			// end
			// else begin
				// for(r=3;r<6;r=r+1) begin
					// for(s=6;s<9;s=s+1) begin
						// if(x!=r && y!=s) begin
							// case(findFinal(r,s))
								// 4'd0: break;	//does nothing if returns 0 because it is not final
								// 4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
								// 4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
								// 4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
								// 4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
								// 4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
								// 4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
								// 4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
								// 4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
								// 4'd9: maybes[728-9*(y*9+x)  -:1] <= 0;
							// endcase
						// end
					// end
				// end
				
			// end
		// end
		// else begin
			// if(y <= 2) begin
				// for(r=6;r<9;r=r+1) begin
					// for(s=0;s<3;s=s+1) begin
						// if(x!=r && y!=s) begin
							// case(findFinal(r,s))
								// 4'd0: break;	//does nothing if returns 0 because it is not final
								// 4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
								// 4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
								// 4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
								// 4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
								// 4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
								// 4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
								// 4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
								// 4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
								// 4'd9: maybes[728-9*(y*9+x)  -:1] <= 0;
							// endcase
						// end
					// end
				// end
				
			// end
			// else if(y <= 5) begin
				// for(r=6;r<9;r=r+1) begin
					// for(s=3;s<6;s=s+1) begin
						// if(x!=r && y!=s) begin
							// case(findFinal(r,s))
								// 4'd0: break;	//does nothing if returns 0 because it is not final
								// 4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
								// 4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
								// 4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
								// 4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
								// 4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
								// 4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
								// 4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
								// 4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
								// 4'd9: maybes[728-9*(y*9+x)  -:1] <= 0;
							// endcase
						// end
					// end
				// end
				
			// end
			// else begin
				// for(r=6;r<9;r=r+1) begin
					// for(s=6;s<9;s=s+1) begin
						// if(x!=r && y!=s) begin
							// case(findFinal(r,s))
								// 4'd0: break;	//does nothing if returns 0 because it is not final
								// 4'd1: maybes[728-9*(y*9+x)-8-:1] <= 0;
								// 4'd2: maybes[728-9*(y*9+x)-7-:1] <= 0;
								// 4'd3: maybes[728-9*(y*9+x)-6-:1] <= 0;
								// 4'd4: maybes[728-9*(y*9+x)-5-:1] <= 0;
								// 4'd5: maybes[728-9*(y*9+x)-4-:1] <= 0;
								// 4'd6: maybes[728-9*(y*9+x)-3-:1] <= 0;
								// 4'd7: maybes[728-9*(y*9+x)-2-:1] <= 0;
								// 4'd8: maybes[728-9*(y*9+x)-1-:1] <= 0;
								// 4'd9: maybes[728-9*(y*9+x)  -:1] <= 0;
							// endcase
						// end
					// end
				// end
				
			// end
		// end
	// end
	// endtask
	
	//horiEightNine
	task automatic horiEightNine;
	integer counte, differenc;
		begin
			counte = 0;
			differenc = 0;
			if(findFinal(4'd0,y) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(4'd0,y);
			end
			if(findFinal(4'd1,y) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(4'd1,y);
			end
			if(findFinal(4'd2,y) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(4'd2,y);
			end
			if(findFinal(4'd3,y) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(4'd3,y);
			end
			if(findFinal(4'd4,y) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(4'd4,y);
			end
			if(findFinal(4'd5,y) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(4'd5,y);
			end
			if(findFinal(4'd6,y) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(4'd6,y);
			end
			if(findFinal(4'd7,y) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(4'd7,y);
			end
			if(findFinal(4'd8,y) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(4'd8,y);
			end
			
			if(counte == 8) begin
				if(findFinal(4'd0,y) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(y*9+0)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(y*9+0)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(y*9+0)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(y*9+0)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(y*9+0)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(y*9+0)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(y*9+0)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(y*9+0)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(y*9+0)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(4'd1,y) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(y*9+1)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(y*9+1)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(y*9+1)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(y*9+1)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(y*9+1)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(y*9+1)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(y*9+1)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(y*9+1)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(y*9+1)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(4'd2,y) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(y*9+2)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(y*9+2)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(y*9+2)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(y*9+2)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(y*9+2)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(y*9+2)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(y*9+2)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(y*9+2)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(y*9+2)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(4'd3,y) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(y*9+3)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(y*9+3)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(y*9+3)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(y*9+3)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(y*9+3)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(y*9+3)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(y*9+3)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(y*9+3)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(y*9+3)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(4'd4,y) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(y*9+4)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(y*9+4)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(y*9+4)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(y*9+4)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(y*9+4)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(y*9+4)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(y*9+4)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(y*9+4)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(y*9+4)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(4'd5,y) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(y*9+5)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(y*9+5)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(y*9+5)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(y*9+5)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(y*9+5)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(y*9+5)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(y*9+5)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(y*9+5)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(y*9+5)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(4'd6,y) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(y*9+6)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(y*9+6)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(y*9+6)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(y*9+6)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(y*9+6)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(y*9+6)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(y*9+6)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(y*9+6)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(y*9+6)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(4'd7,y) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(y*9+7)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(y*9+7)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(y*9+7)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(y*9+7)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(y*9+7)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(y*9+7)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(y*9+7)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(y*9+7)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(y*9+7)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(4'd8,y) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(y*9+8)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(y*9+8)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(y*9+8)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(y*9+8)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(y*9+8)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(y*9+8)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(y*9+8)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(y*9+8)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(y*9+8)-:9] <= 9'b100000000;
					endcase
				end
			end
		end
	endtask
	
	//vertEightNine
	task automatic vertEightNine;
	integer counte, differenc;
		begin
			counte = 0;
			differenc = 0;
			if(findFinal(x,4'd0) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(x,4'd0);
			end
			if(findFinal(x,4'd1) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(x,4'd1);
			end
			if(findFinal(x,4'd2) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(x,4'd2);
			end
			if(findFinal(x,4'd3) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(x,4'd3);
			end
			if(findFinal(x,4'd4) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(x,4'd4);
			end
			if(findFinal(x,4'd5) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(x,4'd5);
			end
			if(findFinal(x,4'd6) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(x,4'd6);
			end
			if(findFinal(x,4'd7) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(x,4'd7);
			end
			if(findFinal(x,4'd8) != 0) begin
				counte = counte + 1'd1;
				differenc = differenc + findFinal(x,4'd8);
			end
			
			if(counte == 8) begin
				if(findFinal(x,4'd0) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(0*9+x)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(0*9+x)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(0*9+x)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(0*9+x)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(0*9+x)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(0*9+x)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(0*9+x)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(0*9+x)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(0*9+x)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(x,4'd1) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(1*9+x)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(1*9+x)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(1*9+x)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(1*9+x)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(1*9+x)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(1*9+x)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(1*9+x)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(1*9+x)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(1*9+x)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(x,4'd2) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(2*9+x)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(2*9+x)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(2*9+x)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(2*9+x)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(2*9+x)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(2*9+x)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(2*9+x)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(2*9+x)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(2*9+x)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(x,4'd3) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(3*9+x)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(3*9+x)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(3*9+x)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(3*9+x)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(3*9+x)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(3*9+x)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(3*9+x)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(3*9+x)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(3*9+x)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(x,4'd4) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(4*9+x)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(4*9+x)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(4*9+x)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(4*9+x)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(4*9+x)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(4*9+x)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(4*9+x)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(4*9+x)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(4*9+x)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(x,4'd5) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(5*9+x)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(5*9+x)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(5*9+x)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(5*9+x)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(5*9+x)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(5*9+x)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(5*9+x)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(5*9+x)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(5*9+x)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(x,4'd6) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(6*9+x)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(6*9+x)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(6*9+x)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(6*9+x)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(6*9+x)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(6*9+x)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(6*9+x)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(6*9+x)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(6*9+x)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(x,4'd7) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(7*9+x)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(7*9+x)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(7*9+x)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(7*9+x)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(7*9+x)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(7*9+x)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(7*9+x)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(7*9+x)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(7*9+x)-:9] <= 9'b100000000;
					endcase
				end
				if(findFinal(x,4'd8) == 0) begin
					case(45-differenc)
						4'd1: maybes[728-9*(8*9+x)-:9] <= 9'b000000001;
						4'd2: maybes[728-9*(8*9+x)-:9] <= 9'b000000010;
						4'd3: maybes[728-9*(8*9+x)-:9] <= 9'b000000100;
						4'd4: maybes[728-9*(8*9+x)-:9] <= 9'b000001000;
						4'd5: maybes[728-9*(8*9+x)-:9] <= 9'b000010000;
						4'd6: maybes[728-9*(8*9+x)-:9] <= 9'b000100000;
						4'd7: maybes[728-9*(8*9+x)-:9] <= 9'b001000000;
						4'd8: maybes[728-9*(8*9+x)-:9] <= 9'b010000000;
						4'd9: maybes[728-9*(8*9+x)-:9] <= 9'b100000000;
					endcase
				end
			end
		end
	endtask
endmodule 
