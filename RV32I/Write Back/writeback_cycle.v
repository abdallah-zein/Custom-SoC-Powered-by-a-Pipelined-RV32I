`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2024 05:16:54 AM
// Design Name: 
// Module Name: writeback_cycle
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


module writeback_cycle(RegWriteW,ResultSrcW, //control inputs
                       ALUResultW,ReadDataW,RdW,PCPlus4W, //inputs
                       ResultW //output
                       );
                       
    //declaration of I/O's
    input             RegWriteW;
    input      [1:0]  ResultSrcW;
    input      [4:0]  RdW;
    input      [31:0] ALUResultW,ReadDataW,PCPlus4W;
    output reg [31:0] ResultW;
    
    always@(*) begin
        case(ResultSrcW)
        0: ResultW = ALUResultW;
        1: ResultW = ReadDataW;
        2: ResultW = PCPlus4W;
        3: ResultW = 0;
        endcase
    end
endmodule
