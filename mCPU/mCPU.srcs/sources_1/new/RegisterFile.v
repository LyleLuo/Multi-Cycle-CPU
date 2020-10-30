`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 17:39:37
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input WE,
	input CLK,
	input[4:0] ReadReg1,
	input[4:0] ReadReg2,
	input[4:0] WriteReg,
	input[31:0] WriteData,
	output[31:0] ReadData1,
	output[31:0] ReadData2
    );
    reg[31:0] registers[0:31];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) registers[i] <= 0;
    end
    assign ReadData1 = ReadReg1 ? registers[ReadReg1] : 0;
    assign ReadData2 = ReadReg2 ? registers[ReadReg2] : 0;
    always@(negedge CLK) begin
        if (WE && WriteReg) registers[WriteReg] <= WriteData;
    end
endmodule
