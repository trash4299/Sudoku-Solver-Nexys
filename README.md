# Sudoku-Solver-Nexys
A Sudoku Solver FPGA using the Nexys Video board and outputting to a 1980 x 1080 screen using HDMI.

Hi, I am only uploading some of the files for the time being. When I get further along in this project I will add in the full folder structure generated by Vivado.

I am currently working on fixing the block diagram and making the hdmi stuff work.

I know I could put the actual solving in C in the SDK and use the microblaze, but I want a challenge by coding in a non-OOP language. Making a C version is probably next.

I am thinking of making a block that always streams parts of the working register and the x and y of it so that the user can see what the solver is trying. The solver works in simulations. Now I need to make the hdmi stuff work and create stuff in the sdk to make a gui to input and output numbers.
