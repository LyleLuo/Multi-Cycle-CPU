`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 17:31:52
// Design Name: 
// Module Name: InsMem
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


module InsMem(
    input [31:0] IAddr,
    input RW,
    output reg [31:0] ins
    );
    reg[7:0] mem[255:0];
    initial begin
        $readmemb("C:/Users/1/Desktop/mCPU/input.txt", mem); 
    end  
    always@(IAddr or RW) begin
        if (RW) ins = {mem[IAddr], mem[IAddr + 1], mem[IAddr + 2], mem[IAddr + 3]};
    end 
endmodule
