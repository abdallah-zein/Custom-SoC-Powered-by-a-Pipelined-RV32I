`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2024 04:58:12 AM
// Design Name: 
// Module Name: MEM_WB_Reg
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


module MEM_WB_Reg(clk,rst,RegWriteM,ResultSrcM,ALUResultM,ReadDataM,RdM,PCPlus4M, // inputs
                          RegWriteW,ResultSrcW,ALUResultW,ReadDataW,RdW,PCPlus4W, // outputs
                          FlushW // hazard unit input
                  );
                  
    input             clk,rst;
    input             FlushW;
    input             RegWriteM;
    input      [1:0]  ResultSrcM;
    input      [4:0]  RdM;
    input      [31:0] ALUResultM,ReadDataM,PCPlus4M;    
    output reg        RegWriteW;
    output reg [1:0]  ResultSrcW;
    output reg [4:0]  RdW;
    output reg [31:0] ALUResultW,ReadDataW,PCPlus4W;
    
    always @(posedge clk or negedge rst) begin
        if (!rst || FlushW) begin
            RegWriteW <= 0;
            ResultSrcW <= 0;
            RdW <= 0;
            ALUResultW <= 0;
            ReadDataW <= 0;
            PCPlus4W <= 0;
        end
        else begin
            RegWriteW <= RegWriteM;
            ResultSrcW <=  ResultSrcM;
            RdW <= RdM;
            ALUResultW <= ALUResultM;
            ReadDataW <= ReadDataM;
            PCPlus4W <= PCPlus4M;
        end
    end
    
    
endmodule
