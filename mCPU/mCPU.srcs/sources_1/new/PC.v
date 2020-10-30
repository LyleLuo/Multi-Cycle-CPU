`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 17:28:15
// Design Name: 
// Module Name: PC
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


module PC(
    input CLK, Reset, PCWre,
    input [31:0] newAddr,
    output reg [31:0] PCAddr
    );
    initial begin  
        PCAddr = 0;  
    end   
    always@(posedge CLK or negedge Reset) begin
        if(Reset==0) PCAddr = 0;
        else if(PCWre) PCAddr = newAddr;
    end
endmodule
