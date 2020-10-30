`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/12 10:07:22
// Design Name: 
// Module Name: Hard_CPU
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


module Hard_CPU(
	input[2:0] display_mode,
	input CLK, Reset, Button,
	output[3:0] AN,	//数码管位选择信号
	output[7:0] Out	
);

	wire[31:0] ALU_Out, CurPC, WriteData, Reg1Out, Reg2Out, instcode, IRInstruction, ADROut, BDROut, DBDROut, ALUoutDROut, Ext_Imm, ALU_Input_A, ALU_Input_B, newAddress, WriteRegAddr;
	wire myCLK, myReset;
	reg[3:0] store;	//记录当前要显示位的值
	wire[2:0] currentState;
	
	mCPU multipleCPU(myCLK, myReset, CurPC, newAddress, instcode, IRInstruction, ADROut, BDROut, DBDROut, ALUoutDROut, Ext_Imm, Reg1Out, Reg2Out, ALU_Input_A, ALU_Input_B, WriteData, WriteRegAddr, currentState);
	remove_shake remove_shake_clk(CLK, !Button, myCLK);
    remove_shake remove_shake_reset(CLK, Reset, myReset);
    clk_slow slowclk(CLK, myReset, AN);
	display show_in_7segment(store, myReset, Out);
	
	always@(myCLK)begin
	   case(AN)
			4'b1110:begin
				case(display_mode)
					3'b000: store <= newAddress[3:0];
					3'b010: store <= ADROut[3:0];
					3'b100: store <= BDROut[3:0];
					3'b110: store <= WriteData[3:0];
					default: store <= {3'b000,currentState[0]};
				endcase
			end
			4'b1101:begin
				case(display_mode)
					3'b000: store <= newAddress[7:4];
					3'b010: store <= ADROut[7:4];
					3'b100: store <= BDROut[7:4];
					3'b110: store <= WriteData[7:4];
                    default: store <= {3'b000,currentState[1]};
				endcase
			end
			4'b1011:begin
				case(display_mode)
					3'b000: store <= CurPC[3:0];
					3'b010: store <= IRInstruction[24:21];
					3'b100: store <= IRInstruction[19:16];
					3'b110: store <= ALUoutDROut[3:0];
                    default: store <= {3'b000,currentState[2]};
				endcase
			end
			4'b0111:begin
				case(display_mode)
					3'b000: store<= CurPC[7:4];
					3'b010: store <= {3'b000,IRInstruction[25]};
					3'b100: store <= {3'b000,IRInstruction[20]};
					3'b110: store <= ALUoutDROut[7:4];
					default: store <= 4'b0000;
				endcase
			end
		endcase
	end
endmodule
