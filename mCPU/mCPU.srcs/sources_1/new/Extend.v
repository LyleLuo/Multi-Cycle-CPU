`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 17:42:57
// Design Name: 
// Module Name: Extend
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


module Extend(
    input ExtSel,
    input [15:0] immed,
    output [31:0] extendImmed
    );
    assign extendImmed = {ExtSel && immed[15] ? 16'hffff : 16'h0000, immed};
endmodule
