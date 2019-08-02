`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2019 11:40:58 AM
// Design Name: 
// Module Name: sudokuSim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define CLOCKTIME 1000 //1000ns for 100MHz

 module sudokuSim();
	reg  start_tb;
	bit  clk_tb;
	reg [323:0] enter_tb;
	wire readyToStart_tb;
	wire done_tb;
	wire [323:0] out_tb;
	
	always #`CLOCKTIME clk_tb <= ~clk_tb;
	
	sudoku_v DUT(.start(start_tb),.clk(clk_tb),.enter(enter_tb),.readyToStart(readyToStart_tb),.done(done_tb),.out(out_tb));
	
	initial begin
		clk_tb = 0;
		enter_tb <= {{4'd0,4'd7,4'd6,4'd3,4'd1,4'd4,4'd9,4'd5,4'd8},{4'd8,4'd5,4'd4,4'd9,4'd6,4'd2,4'd7,4'd1,4'd3},{4'd9,4'd1,4'd3,4'd8,4'd7,4'd5,4'd2,4'd6,4'd4},{4'd4,4'd6,4'd8,4'd1,4'd2,4'd7,4'd3,4'd9,4'd5},{4'd5,4'd9,4'd7,4'd4,4'd3,4'd8,4'd6,4'd2,4'd1},{4'd1,4'd3,4'd2,4'd5,4'd9,4'd6,4'd4,4'd8,4'd7},{4'd3,4'd2,4'd5,4'd7,4'd8,4'd9,4'd1,4'd4,4'd6},{4'd6,4'd4,4'd1,4'd2,4'd5,4'd3,4'd8,4'd7,4'd9},{4'd7,4'd8,4'd9,4'd6,4'd4,4'd1,4'd5,4'd3,4'd2}};
		#10ns;
		start_tb <= 1;
		#15ns;
		//start_tb <= 0;
		#20000ns;
		$finish;
	end
endmodule
