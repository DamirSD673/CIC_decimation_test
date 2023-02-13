`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2023 11:49:24 AM
// Design Name: 
// Module Name: sinus_generator
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


module sinus_generator(
    input clk,
    output reg [15:0] sinus
    );
    parameter LENGTH = 1000;
    reg [15:0] sin_rom [LENGTH-1:0];
    integer i;
    initial begin 
        $readmemh("sine.mem", sin_rom);
        i = 0;
    end
    always @(posedge clk)
    begin
        sinus = sin_rom[i];
        i = i + 1;
        if (i == LENGTH)
            i = 0;
    end
endmodule
