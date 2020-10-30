`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 17:56:09
// Design Name: 
// Module Name: Mux_3
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


module Mux_3(
    input[1:0] Select,
    input[31:0] in1,
    input[31:0] in2,
    input[31:0] in3,
    output[31:0] out
    );
    assign out = Select == 2'b00 ? in1 : Select == 2'b01 ? in2 : in3;
    
//    case(Select)
//        2'b00 : assign out = in1;
//        2'b01 : assign out = in2;
//        2'b10 : assign out = in3;        
//    endcase
    
endmodule
