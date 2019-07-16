module sudoku_v(input start,input[323:0] enter,output readyToStart,output[323:0] out);
	
	reg [8:0] maybes [8:0][8:0];
	integer MC,x,y,ex,why,i,k,n,h,g;
	reg readyToStar;
	
	assign readyToStart = readyToStar;
	
	initial
	begin
	readyToStar <= 0;
		for(i = 8; i >= 0; i = i - 1) begin : row
			for(k = 8; k >= 0; k = k - 1) begin : column
				ex = 4*(i*9+k);
				case(enter[ex+:3])
				4'b0000 : maybes[i][k] <= "111111111";
				4'b0001 : maybes[i][k] <= "000000001";
				4'b0010 : maybes[i][k] <= "000000010";
				4'b0011 : maybes[i][k] <= "000000100";
				4'b0100 : maybes[i][k] <= "000001000";
				4'b0101 : maybes[i][k] <= "000010000";
				4'b0110 : maybes[i][k] <= "000100000";
				4'b0111 : maybes[i][k] <= "001000000";
				4'b1000 : maybes[i][k] <= "010000000";
				4'b1001 : maybes[i][k] <= "100000000";
				endcase
			end
		end
		
		x <= 0;
		y <= 0;
		MC <= 0;
		readyToStar <= 1;
	end
	
	always @(*) begin
		if(MC == 0) begin
		  if(start == 1)
		      MC <= 1;
		end
		else if(MC == 1) begin
			//all checking tasks
			colchecker();
			rowchecker();
			
			
			n <= 0;
			for(h = 0; h < 9; h = h + 1) begin
				for(g = 0; g < 9; g = g + 1) begin
					if(isFinal(h,g) == 1)
						n <= n + 1;
				end
			end
			if (n == 81)
				MC <= 2; //this might not work
			else
				MC <= 1;
		end
		
		else if(MC == 2) begin
			//assign out pins using finnum task
		end
		
	end

	//rowchecker task
	task rowChecker;
		integer f;
		for(f = 0; f < 9; f = f + 1) begin
			if(f != y) begin
				if(isFinal(x,f) == 1) begin
					case(f) //figure out how to find the finnum
						4'b0000 : break;
						4'b0001 : if(maybes[x][y][0] == 1) maybes[x][y][0] <= 0;
						4'b0010 : if(maybes[x][y][1] == 1) maybes[x][y][1] <= 0;
						4'b0011 : if(maybes[x][y][2] == 1) maybes[x][y][2] <= 0;
						4'b0100 : if(maybes[x][y][3] == 1) maybes[x][y][3] <= 0;
						4'b0101 : if(maybes[x][y][4] == 1) maybes[x][y][4] <= 0;
						4'b0110 : if(maybes[x][y][5] == 1) maybes[x][y][5] <= 0;
						4'b0111 : if(maybes[x][y][6] == 1) maybes[x][y][6] <= 0;
						4'b1000 : if(maybes[x][y][7] == 1) maybes[x][y][7] <= 0;
						4'b1001 : if(maybes[x][y][8] == 1) maybes[x][y][8] <= 0;
					endcase
				end
			end
		end
	endtask


	
	//colchecker task
	task colChecker;
		integer f;
		for(f = 0; f < 9; f = f + 1) begin
			if(f != x) begin
				if(isFinal(f,y) == 1) begin
					case(f) //figure out how to find the finnum
						4'b0000 : break;
						4'b0001 : if(maybes[x][y][0] == 1) maybes[x][y][0] <= 0;
						4'b0010 : if(maybes[x][y][1] == 1) maybes[x][y][1] <= 0;
						4'b0011 : if(maybes[x][y][2] == 1) maybes[x][y][2] <= 0;
						4'b0100 : if(maybes[x][y][3] == 1) maybes[x][y][3] <= 0;
						4'b0101 : if(maybes[x][y][4] == 1) maybes[x][y][4] <= 0;
						4'b0110 : if(maybes[x][y][5] == 1) maybes[x][y][5] <= 0;
						4'b0111 : if(maybes[x][y][6] == 1) maybes[x][y][6] <= 0;
						4'b1000 : if(maybes[x][y][7] == 1) maybes[x][y][7] <= 0;
						4'b1001 : if(maybes[x][y][8] == 1) maybes[x][y][8] <= 0;
					endcase
				end
			end
		end
	endtask
	
	//isFinal function
	function isFinal;
		input [3:0] x;
		input [3:0] y;
		
		integer count, f;
		begin
			case(maybes[x][y])
			8'b10000000: isFinal = 1;
			8'b01000000: isFinal = 1;
			8'b00100000: isFinal = 1;
			8'b00010000: isFinal = 1;
			8'b00001000: isFinal = 1;
			8'b00000100: isFinal = 1;
			8'b00000010: isFinal = 1;
			8'b00000001: isFinal = 1;
			default: isFinal = 0;
			endcase
		end
	endfunction
	
	
	
	//squarechecker task
	//	task squareChecker; begin
		
		
		
		
	//         end
	//         endtask

	//rowpossibilities ??
	//colpossibilities ??
	//horiEightNine ??
	//vertEightNine ?? 
		
			
endmodule 
