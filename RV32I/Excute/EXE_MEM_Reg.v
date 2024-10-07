`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2024 02:24:06 AM
// Design Name: 
// Module Name: EXE_MEM_Reg
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


module EXE_MEM_Reg(clk,rst,RegWriteE,ResultSrcE,MemWriteE,MemSizeE,ALUResultE,WriteDataE,RdE,PCPlus4E,IsPerE,  // inputs
                           RegWriteM,ResultSrcM,MemWriteM,MemSizeM,ALUResultM,WriteDataM,RdM,PCPlus4M,IsPerM,   //outputs
                           StallM); //Hazard unit input
    
    input             clk,rst;
    input             StallM;
    input             RegWriteE,MemWriteE,IsPerE;
    input      [1:0]  ResultSrcE, MemSizeE;
    input      [4:0]  RdE;
    input      [31:0] ALUResultE,WriteDataE,PCPlus4E;
    output reg        RegWriteM,MemWriteM,IsPerM;
    output reg [1:0]  ResultSrcM, MemSizeM;
    output reg [4:0]  RdM;
    output reg [31:0] ALUResultM,WriteDataM,PCPlus4M;
    
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            RegWriteM <= 0;
            ResultSrcM <= 0;
            MemWriteM <= 0;
            MemSizeM <= 0;
            ALUResultM <= 0;
            WriteDataM <= 0;
            RdM <= 0;
            PCPlus4M <= 0;
            IsPerM <= 0;
        end
        else begin
            if (StallM==0) begin
                RegWriteM <= RegWriteE;
                ResultSrcM <= ResultSrcE;
                MemWriteM <= MemWriteE;
                MemSizeM <= MemSizeE;
                ALUResultM <= ALUResultE;
                WriteDataM <= WriteDataE;
                RdM <= RdE;
                PCPlus4M <= PCPlus4E;
                IsPerM <= IsPerE;
            end
        end
    end    
endmodule
