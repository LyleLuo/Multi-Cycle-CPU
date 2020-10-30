`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 16:28:23
// Design Name: 
// Module Name: DataMem
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


module DataMem(
    input CLK,
    input mRD,
    input mWR,
    input[31:0] DAddr,
    input[31:0] DataIn,
    output reg[31:0] DataOut
    );
    
    reg[7:0] dataMemory[255:0];
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) dataMemory[i] <= 0;//没有自增运算符
    end
    
    always@(mRD or DAddr) begin
        if (mRD) begin
            DataOut[31:24] <= dataMemory[DAddr+3];
            DataOut[23:16] <= dataMemory[DAddr+2];
            DataOut[15:8] <= dataMemory[DAddr+1];
            DataOut[7:0] <= dataMemory[DAddr];
        end
    end
    
    always@(negedge CLK) begin
        if (mWR) begin
            dataMemory[DAddr+3] <= DataIn[31:24];
            dataMemory[DAddr+2] <= DataIn[23:16];
            dataMemory[DAddr+1] <= DataIn[15:8];
            dataMemory[DAddr] <= DataIn[7:0];
        end 
    end
endmodule
