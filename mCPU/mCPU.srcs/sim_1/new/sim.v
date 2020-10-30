`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/08 13:46:55
// Design Name: 
// Module Name: sim
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


module sim;
    reg CLK;
    reg Reset;
    wire[31:0] CurPC, nextAddr, instcode, IRInstruction, ADROut, BDROut, DBDROut, ALUoutDROut, Ext_Imm, WriteData, Reg1Out, Reg2Out, ALU_Input_A, ALU_Input_B;
    wire[4:0] WriteRegAddr;
    wire[2:0] currentState;
    mCPU multipleCPU(CLK, Reset, CurPC, nextAddr, instcode, IRInstruction, ADROut, BDROut, DBDROut, ALUoutDROut, Ext_Imm, Reg1Out, Reg2Out, ALU_Input_A, ALU_Input_B, WriteData, WriteRegAddr, currentState);
    initial begin
        CLK = 1;
        Reset = 0;
        #1;
        Reset = 1;
        forever #50 CLK = !CLK;
    end
endmodule
