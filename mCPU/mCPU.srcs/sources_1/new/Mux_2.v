`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 17:42:15
// Design Name: 
// Module Name: Mux_2
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


module Mux_2(
    input Select,
    input[31:0] in1,
    input[31:0] in2,
    output[31:0] out
    );
    assign out = Select ? in2 : in1;
endmodule
