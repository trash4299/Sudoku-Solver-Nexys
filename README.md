# Sudoku-Solver-Nexys
A Sudoku Solver FPGA using the Nexys Video board and outputting to a 1980 x 1080 screen using HDMI.

Hi, I am only uploading some of the files for the time being. When I get further along in this project I will add in the full folder structure generated by Vivado

I need to fix my sudoku module so that I can actually fit it on to the FPGA. Rght now, my design would use over 200% of the LUTs on the Nexys Video. The solver module is currently would need about 291,000 LUTs when I only have about 110,000 available for it. There are lots of things I could improve on and minimize and I am slowly learning and figuring them out. 
I know I could put the actual solving in C in the SDK and use the microblaze, but I want a challenge by coding in a non-OOP language. Making a C version is probably next.

I will be merging the NewSudoku branch into the master soon. 
