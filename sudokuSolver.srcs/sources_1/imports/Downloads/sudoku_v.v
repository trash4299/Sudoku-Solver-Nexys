module sudoku_v(input start,input[323:0] enter,output reg readyToStart,output[323:0] out);
	
	reg [8:0] maybes [8:0][8:0];
	integer MC,x,y,ex,why,i,k,n,h,g;
    integer f,a,b,r,s,differenc,counte;
    
	initial readyToStart = 1;
	
	always @(*) begin
		if(MC == 0) begin
			readyToStart <= 0;
			//requires the numbers to be imported as 4-bit numbers, reading left to right and top down
			for(i = 0; i < 9; i = i + 1) begin : row
				for(k = 0; k < 9; k = k + 1) begin : column
					case(enter[4*(i*9+k)+:3])
						4'b0000: maybes[i][k] <= "111111111";
						4'b0001: maybes[i][k] <= "000000001";
						4'b0010: maybes[i][k] <= "000000010";
						4'b0011: maybes[i][k] <= "000000100";
						4'b0100: maybes[i][k] <= "000001000";
						4'b0101: maybes[i][k] <= "000010000";
						4'b0110: maybes[i][k] <= "000100000";
						4'b0111: maybes[i][k] <= "001000000";
						4'b1000: maybes[i][k] <= "010000000";
						4'b1001: maybes[i][k] <= "100000000";
					endcase
				end
			end
			MC = 1;
		end
		else if(MC == 1) begin
			x <= 0;
			y <= 0;
			if(start == 1) begin
				MC <= 1;
				readyToStart <= 0;
			end
		end
		else if(MC == 2) begin
			//all checking tasks
			for(x = 0;x < 9;x = x + 1) begin
				for(y = 0;y < 9; y = y + 1) begin
					colChecker();
					rowChecker();
					vertEightNine();
					horiEightNine();
					squareChecker();
				end 
			end
			n <= 0;
			for(h = 0; h < 9; h = h + 1) begin
				for(g = 0; g < 9; g = g + 1) begin
					if(findFinal(h,g) != 0)
						n <= n + 1;
				end
			end
			if (n == 81)
				MC <= 2; //this might not work
			else begin
				MC <= 1;
			end
		end
		
		else if(MC == 3) begin
			//assign output vector using finnum task
		end
		
	end
	
	//funcations and tasks
	
	function findFinal; //returns 0 is the cell is not final
		input [3:0] ex;
		input [3:0] why;
		
		begin
			case(maybes[ex][why])
                9'b100000000: findFinal = 9;
                9'b010000000: findFinal = 8;
                9'b001000000: findFinal = 7;
                9'b000100000: findFinal = 6;
                9'b000010000: findFinal = 5;
                9'b000001000: findFinal = 4;
                9'b000000100: findFinal = 3;
                9'b000000010: findFinal = 2;
                9'b000000001: findFinal = 1;
                default: findFinal = 0;
			endcase
		end
	endfunction
	
	//rowchecker task
	task rowChecker;
		for(f = 0; f < 9; f = f + 1) begin
			if(f != y) begin
				case(findFinal(x,f))
//					4'b0000 break;	//does nothing if returns 0 because it is not final
					4'b0001: maybes[x][y][0] <= 0;
					4'b0010: maybes[x][y][1] <= 0;
					4'b0011: maybes[x][y][2] <= 0;
					4'b0100: maybes[x][y][3] <= 0;
					4'b0101: maybes[x][y][4] <= 0;
					4'b0110: maybes[x][y][5] <= 0;
					4'b0111: maybes[x][y][6] <= 0;
					4'b1000: maybes[x][y][7] <= 0;
					4'b1001: maybes[x][y][8] <= 0;
				endcase
			end
		end
	endtask
	
	//colchecker task
	task colChecker;
		for(f = 0; f < 9; f = f + 1) begin
			if(f != x) begin
				case(findFinal(f,y))
//					4'b0000: break;	//does nothing if returns 0 because it is not final
					4'b0001: maybes[x][y][0] <= 0;
					4'b0010: maybes[x][y][1] <= 0;
					4'b0011: maybes[x][y][2] <= 0;
					4'b0100: maybes[x][y][3] <= 0;
					4'b0101: maybes[x][y][4] <= 0;
					4'b0110: maybes[x][y][5] <= 0;
					4'b0111: maybes[x][y][6] <= 0;
					4'b1000: maybes[x][y][7] <= 0;
					4'b1001: maybes[x][y][8] <= 0;
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
						4'd1: maybes[x][y][0] <= 0;
						4'd2: maybes[x][y][1] <= 0;
						4'd3: maybes[x][y][2] <= 0;
						4'd4: maybes[x][y][3] <= 0;
						4'd5: maybes[x][y][4] <= 0;
						4'd6: maybes[x][y][5] <= 0;
						4'd7: maybes[x][y][6] <= 0;
						4'd8: maybes[x][y][7] <= 0;
						4'd9: maybes[x][y][8] <= 0;
//						4'd0: break;	//does nothing if returns 0 because it is not final
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
						4'b0001: maybes[r][y] <= "000000001";
						4'b0010: maybes[r][y] <= "000000010";
						4'b0011: maybes[r][y] <= "000000100";
						4'b0100: maybes[r][y] <= "000001000";
						4'b0101: maybes[r][y] <= "000010000";
						4'b0110: maybes[r][y] <= "000100000";
						4'b0111: maybes[r][y] <= "001000000";
						4'b1000: maybes[r][y] <= "010000000";
						4'b1001: maybes[r][y] <= "100000000";
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
						4'b0001: maybes[x][r] <= "000000001";
						4'b0010: maybes[x][r] <= "000000010";
						4'b0011: maybes[x][r] <= "000000100";
						4'b0100: maybes[x][r] <= "000001000";
						4'b0101: maybes[x][r] <= "000010000";
						4'b0110: maybes[x][r] <= "000100000";
						4'b0111: maybes[x][r] <= "001000000";
						4'b1000: maybes[x][r] <= "010000000";
						4'b1001: maybes[x][r] <= "100000000";
					endcase
                end
            end
        end
    end
	endtask
	
endmodule 
