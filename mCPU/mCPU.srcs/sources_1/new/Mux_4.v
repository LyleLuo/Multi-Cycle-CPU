`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 17:56:32
// Design Name: 
// Module Name: Mux_4
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


module Mux_4(   
    input[1:0] Select,
    input[31:0] in1,
    input[31:0] in2,
    input[31:0] in3,
    input[31:0] in4,
    output[31:0] out
    );
    assign out = Select == 2'b00 ? in1 : Select == 2'b01 ? in2 : Select == 2'b10 ? in3 : in4;
endmodule
