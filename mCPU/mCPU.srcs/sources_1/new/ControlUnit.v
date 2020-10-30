`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 17:59:30
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input CLK,
	input[5:0] op,
    input zero,
    input sign,
    input reset,
    output ExtSel,
	output reg PCWre,
	output RegWre,
    output InsMemRW,
	output[1:0] RegDst,
    output ALUSrcA,
    output ALUSrcB,
    output[1:0] PCSrc,
	output[2:0] ALUOp,
	output mRD,
	output reg mWR,
	output reg IRWre,
	output WrRegDSrc,
	output DBDataSrc,
	output reg[2:0] currentState//try
    );
    //对指令和ALU的操作码定义常量
    parameter INS_ADD = 6'b000000;
    parameter INS_SUB = 6'b000001;
    parameter INS_ADDIU = 6'b000010;
    parameter INS_AND = 6'b010000;
    parameter INS_ANDI = 6'b010001;
    parameter INS_ORI = 6'b010010;
    parameter INS_XORI = 6'b010011;
    parameter INS_SLL = 6'b011000;
    parameter INS_SLTI = 6'b100110;
    parameter INS_SLT = 6'b100111;
    parameter INS_SW = 6'b110000;
    parameter INS_LW = 6'b110001;
    parameter INS_BEQ = 6'b110100;
    parameter INS_BNE = 6'b110101;
    parameter INS_BLTZ = 6'b110110;
    parameter INS_J = 6'b111000;
    parameter INS_JR = 6'b111001;
    parameter INS_JAL = 6'b111010;
    parameter INS_HALT = 6'b111111;
    
    parameter ALU_ADD = 3'b000;
    parameter ALU_SUB = 3'b001;
    parameter ALU_SLL = 3'b010;
    parameter ALU_OR = 3'b011;
    parameter ALU_AND = 3'b100;
    parameter ALU_SLTU = 3'b101;
    parameter ALU_SLT = 3'b110;
    parameter ALU_XOR = 3'b111;

    parameter[2:0] IF = 3'b000;
    parameter[2:0] ID = 3'b001;
    parameter[2:0] EXELS = 3'b010;//lw sw
    parameter[2:0] MEM = 3'b011;
    parameter[2:0] WBL= 3'b100;//lw
    parameter[2:0] EXEBR = 3'b101;//beq bne bltz
    parameter[2:0] EXEAL = 3'b110;//Arithmetic and Logic
    parameter[2:0] WBAL = 3'b111;

    

    initial begin
        currentState = IF;
    end
    
    //PCWre, mWR是写信号，一个阶段的周期不能写其他阶段的值，除了在最后可以写PC外
    always@(negedge CLK or negedge reset) begin
        if(reset == 0) begin  //初始化什么也不能写
            currentState <= IF;
            PCWre = 0;
            mWR = 0;
            IRWre = 0;
        end
        else begin
            case (currentState)
                IF: begin
                    currentState <= ID;
                    PCWre = 0;
                    mWR = 0;
                    IRWre = 1;
                end
                ID: begin
                    case (op)
                        INS_BEQ, INS_BNE, INS_BLTZ: currentState <= EXEBR;
                        INS_SW, INS_LW: currentState <= EXELS;
                        INS_J, INS_JAL, INS_JR, INS_HALT: begin
                            if (op == INS_HALT) PCWre = 0;
                            else PCWre = 1;//跳转指令结束，写pc    
                            currentState <= IF;
                        end
                        default: currentState <= EXEAL;
                    endcase
                    IRWre = 0;
                end
                EXEAL:begin
                    currentState <= WBAL;
                end
                EXELS:begin
                    currentState <= MEM;
                    //如果指令为SW，mem阶段允许写内存
                    if (op == INS_SW)  mWR = 1;
                end
                MEM:begin
                    if (op == INS_SW) begin
                        currentState = IF;
                        //指令sw结束，写PC
                        PCWre=1;
                    end
                    else begin
                        currentState = WBL;
                        //指令lw的wb阶段写寄存器
                    end
                    mWR = 0;
                end
                default: begin
                    currentState <= IF;
                    PCWre = 1;
                end
            endcase
        end
    end
    assign RegWre = currentState == WBAL || currentState == WBL || currentState == ID && op == INS_JAL;
    assign ALUSrcA = op == INS_SLL;
    assign ALUSrcB = op == INS_ADDIU || op == INS_ANDI || op == INS_ORI || op == INS_XORI || op == INS_SLTI || op == INS_SW || op == INS_LW;
    assign DBDataSrc = op == INS_LW;
    assign WrRegDSrc = op != INS_JAL;
    assign InsMemRW = 1;
    assign mRD = op == INS_LW;
    assign RegDst = op == INS_JAL ? 2'b00: op == INS_ADD || op == INS_SUB || op == INS_AND || op == INS_SLT || op == INS_SLL ? 2'b10 : 2'b01;
    assign ExtSel = op != INS_ANDI && op != INS_ORI && op != INS_XORI;
    assign PCSrc = op == INS_J || op == INS_JAL ? 2'b11 : op == INS_JR ? 2'b10 : (op == INS_BEQ && zero == 1) || (op == INS_BNE && zero == 0) || (op == INS_BLTZ && sign == 1) ? 2'b01 : 2'b00;
    assign ALUOp = op == INS_SUB || op == INS_BEQ || op == INS_BNE || op == INS_BLTZ ? ALU_SUB:
                    op == INS_SLL ? ALU_SLL:
                    op == INS_ORI ? ALU_OR:
                    op == INS_ANDI || op == INS_AND ? ALU_AND:
                    op == INS_SLT || op == INS_SLTI ? ALU_SLT:
                    op == INS_XORI ? ALU_XOR : ALU_ADD;
endmodule