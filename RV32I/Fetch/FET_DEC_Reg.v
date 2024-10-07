`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2024 01:15:44 AM
// Design Name: 
// Module Name: FET_DEC_Reg
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


module FET_DEC_Reg(instrF, instrD, pcF, pcD, pc_plus4F, pc_plus4D, StallD, FlushD, clk,rst);
    input clk, rst;
    input StallD, FlushD; // Hazards signal
    input [31:0] instrF, pcF, pc_plus4F;
    output reg [31:0] instrD, pcD, pc_plus4D;
    
    always @(posedge clk or negedge rst) begin
        if (!rst || FlushD) begin
            instrD <= 0;
            pcD <= 0;
            pc_plus4D <= 0;
        end
        else if (StallD==0) begin
            instrD <= instrF;
            pcD <= pcF;
            pc_plus4D <= pc_plus4F;
        end
    end
    
endmodule
