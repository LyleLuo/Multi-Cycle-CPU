`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 21:24:22
// Design Name: 
// Module Name: mCPU
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


module mCPU(
    input CLK,
	input Reset,
	output[31:0] CurPC, nextAddr, instcode, IRInstruction, ADROut, BDROut, DBDROut, ALUoutDROut, Ext_Imm, Reg1Out, Reg2Out, ALU_Input_A, ALU_Input_B, WriteData,
	output[4:0] WriteRegAddr,
	output[2:0] currentState
);
	wire ExtSel, PCWre, InsMemRW, ALUSrcA, ALUSrcB, RD, WR, DBDataSrc, zero, sign, IRWre, WrRegDSrc, RegWre;
	wire[2:0] ALUOp;
	wire[1:0] PCSrc, RegDst;
	wire[31:0] MemOut, PC4, InsSrcImm, InsSrc1, InsSrc3, ALU_Out, WBData;
	
	PC pc(CLK, Reset, PCWre, nextAddr, CurPC);
	InsMem insmem(CurPC, InsMemRW, instcode);//not
	tempReg IR(CLK, instcode, IRWre, IRInstruction);//hkhk
	Adder pc4_adder(CurPC, 32'b00000000000000000000000000000100, PC4);
	Mux_3 reg_w_choose(RegDst, 5'b11111, IRInstruction[20:16],IRInstruction[15:11], WriteRegAddr);
	Mux_2 writedata_choose(WrRegDSrc, PC4, DBDROut, WriteData);
	RegisterFile regfile(RegWre, CLK, IRInstruction[25:21], IRInstruction[20:16], WriteRegAddr, WriteData, Reg1Out, Reg2Out);
	tempReg ADR(CLK, Reg1Out, 1'b1, ADROut);
    tempReg BDR(CLK, Reg2Out, 1'b1, BDROut);
    Extend extend(ExtSel, IRInstruction[15:0], Ext_Imm);
	Mux_2 alua_choose(ALUSrcA, ADROut, {27'b000000000000000000000000000,IRInstruction[10:6]}, ALU_Input_A);
    Mux_2 alub_choose(ALUSrcB, BDROut, Ext_Imm, ALU_Input_B);
	ALU alu(ALUOp, ALU_Input_A, ALU_Input_B, ALU_Out, zero, sign);
	tempReg ALUoutDR(CLK, ALU_Out, 1'b1, ALUoutDROut);
    tempReg DBDR(CLK, WBData, 1'b1, DBDROut);
	DataMem datamem(CLK, RD, WR, ALUoutDROut, BDROut, MemOut);
	Mux_2 db_choose(DBDataSrc, ALU_Out, MemOut, WBData);
    LeftShift_2 after_imm_extend(Ext_Imm, InsSrcImm);
	LeftShift_2 addr_shift({2'b00, PC4[31:28], IRInstruction[25:0]}, InsSrc3);
	Adder next_pc1(InsSrcImm, PC4, InsSrc1);
	Mux_4 nextpc_choose(PCSrc, PC4, InsSrc1, Reg1Out,InsSrc3, nextAddr);
	ControlUnit control_unit(CLK, IRInstruction[31:26], zero, sign, Reset, ExtSel, PCWre, RegWre, InsMemRW, RegDst, ALUSrcA, ALUSrcB, PCSrc, ALUOp, RD, WR, IRWre, WrRegDSrc, DBDataSrc, currentState);
endmodule
