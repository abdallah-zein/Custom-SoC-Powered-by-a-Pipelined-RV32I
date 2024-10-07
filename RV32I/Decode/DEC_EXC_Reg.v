`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2024 09:28:03 PM
// Design Name: 
// Module Name: DEC_EXC_Reg
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


module DEC_EXC_Reg(RegWriteD,RegWriteE,ResultSrcD,ResultSrcE,MemWriteD,MemWriteE,JumpD,JumpE,
                   BranchD,BranchE,ALUCtrlD,ALUCtrlE,ALUSrcD,ALUSrcE,MemSizeD,MemSizeE,PCD,PCE,
                   Rs1D,Rs1E,Rs2D,Rs2E,RdD,RdE,ExtImmD,ExtImmE,PCPlus4D,PCPlus4E,StallE,FlushE,clk,rst,
                   RD1D,RD1E,RD2D,RD2E);
    
    input RegWriteD,MemWriteD,JumpD,BranchD,ALUSrcD,StallE,FlushE;
    input clk,rst;
    input [1:0] ResultSrcD,MemSizeD;
    input [3:0] ALUCtrlD;
    input [31:0] RD1D,RD2D,PCD,ExtImmD,PCPlus4D;
    input [4:0] Rs1D,Rs2D,RdD;
    output reg [4:0] Rs1E,Rs2E,RdE;
    output reg [31:0] RD1E,RD2E,PCE,ExtImmE,PCPlus4E;
    output reg [3:0] ALUCtrlE;
    output reg [1:0] ResultSrcE,MemSizeE;
    output reg RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE;
    
    always @(posedge clk or negedge rst) begin
        if (!rst || FlushE) begin
            RegWriteE <= 0;
            ResultSrcE <= 0;
            MemWriteE <= 0;
            JumpE <= 0;
            BranchE <= 0;
            ALUCtrlE <= 0;
            ALUSrcE <= 0;
            MemSizeE <= 0;
            RD1E <= 0;
            RD2E <= 0;
            PCE <= 0;
            Rs1E <= 0;
            Rs2E <= 0;
            RdE <= 0;
            ExtImmE <= 0;
            PCPlus4E <= 0;
        end
        else begin
            if (StallE == 0) begin
                RegWriteE <= RegWriteD;
                ResultSrcE <= ResultSrcD;
                MemWriteE <= MemWriteD;
                JumpE <= JumpD;
                BranchE <= BranchD;
                ALUCtrlE <= ALUCtrlD;
                ALUSrcE <= ALUSrcD;
                MemSizeE <= MemSizeD;
                RD1E <= RD1D;
                RD2E <= RD2D;
                PCE <= PCD;
                Rs1E <= Rs1D;
                Rs2E <= Rs2D;
                RdE <= RdD;
                ExtImmE <= ExtImmD;
                PCPlus4E <= PCPlus4D;
            end
        end
    end
endmodule
