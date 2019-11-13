# Sudoku-Solver-Nexys
A Sudoku Solver FPGA using the Nexys Video board that takes input through HDMI and outputs to a screen using HDMI.

Hi, I am only uploading some of the files for the time being. When I get further along in this project I will add in the full folder structure generated by Vivado.

I am currently working on fixing timing issues with the rgb2dvi, dvi2rgb, axi_vdma, and mig ip cores. This will be an interesting problems to solve with the mixed clock domains

I know I could put the actual solving in C in the SDK and use the microblaze, but I want a challenge by coding in a non-OOP language. Making a C version is probably next.

I am thinking of making a block that always streams parts of the working register and the x and y of it so that the user can see what the solver is trying. The solver works in simulations.
