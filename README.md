# Sudoku-Solver-Nexys
This project is bad

I am archiving this project and I am going to start over and just take my solver module. It will take a lot more time to try to figure out what is going wrong because it has something to do with file paths and stuff missing and this project contains a lot of extra unused files. Also I will upload the full file structure in the next project.

A Sudoku Solver FPGA using the Nexys Video board that takes input through HDMI and outputs to a screen using HDMI.

Hi, I am only uploading some of the files for the time being. When I get further along in this project I will add in the full folder structure generated by Vivado.

I am currently working on fixing timing issues with the rgb2dvi, dvi2rgb, axi_vdma, and mig ip cores. This will be an interesting problems to solve with the mixed clock domains

I know I could put the actual solving in C in the SDK and use the microblaze, but I want a challenge by coding in a non-OOP language. Making a C version is probably next.

I am thinking of making a block that always streams parts of the working register and the x and y of it so that I can have it displayed on the screen as it is trying solutions.

I am thinking about using AXIStream to add the working register to memory rather than have it contained in the module. But I would need to change the main FSM to work with multi clock cycles.

Hi, I am back to school and I just installed Vivado up on my machine, but I am getting some weird problems. I think I exported it and imported my project wrong so there is something weird going on with the file paths. I may or may not copy the block deisgn and sources to a new project and start over. Also on my to-do list is figuring out how to get Vivado generated tcl scripts so that the block design can copied easily.
I am not sure how much time I will have to work on this, but I want to finish this project by the end of the school year (May 2020). 


Future future plans:
After I finish this project, I want to add on more to the GUI so that the user can upload a hand-written partially completed Sudoku puzzle and use machine learning to decipher numbers and solve it. But that is a little bit aways. 
