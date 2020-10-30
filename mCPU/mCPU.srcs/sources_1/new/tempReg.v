`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 19:12:06
// Design Name: 
// Module Name: tempReg
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


module tempReg(
        input CLK,
        input [31:0] IData,
        input write,
        output reg[31:0] OData
    );

    initial begin 
        OData = 0;
    end

    always@(posedge CLK) begin
        if (write == 1) OData <= IData;
    end
endmodule
