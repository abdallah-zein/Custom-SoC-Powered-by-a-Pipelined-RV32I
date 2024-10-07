`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2024 04:41:33 AM
// Design Name: 
// Module Name: memory_cycle
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


module memory_cycle(RegWriteM,ResultSrcM,MemWriteM,MemSizeM, //control inputs
                    clk,rst,ALUResultM,WriteDataM,RdM,PCPlus4M,IsPerM, // inputs
                    RegWriteW,ResultSrcW,ALUResultW,ReadDataW,RdW,PCPlus4W, // outputs
                    FlushW, // control unit input
                    proc_rdata // APB Input Signal
                    );
                    
    //declaration of I/O's
    input         clk,rst;
    input         FlushW;
    input         RegWriteM,MemWriteM,IsPerM;
    input  [1:0]  ResultSrcM,MemSizeM;
    input  [4:0]  RdM;
    input  [31:0] ALUResultM,WriteDataM,PCPlus4M;
    output        RegWriteW;
    output [1:0]  ResultSrcW;
    output [4:0]  RdW;
    output [31:0] ALUResultW,ReadDataW,PCPlus4W;
    
    //APB Signals
    input  [31:0] proc_rdata;
    
    //declaration of internal wires
    wire [31:0] ReadDataM, RD;
    wire        WESrc;

    
    //declare Write enable source MUX
    assign WESrc = (IsPerM)? 0 : MemWriteM; 
    
    //declare Data Source MUX
    assign ReadDataM = (IsPerM)? proc_rdata : RD;
    
    //declare the data memory
    data_memory DataMem(
                        .clk(clk),
                        .A(ALUResultM),
                        .RD(RD),
                        .WD(WriteDataM),
                        .WE(WESrc),
                        .MemSize(MemSizeM)
                        );
                        
    //declare Memory-WriteBack Register
    MEM_WB_Reg M_WB_Reg(
                        .clk(clk),
                        .rst(rst),
                        .RegWriteM(RegWriteM),
                        .ResultSrcM(ResultSrcM),
                        .ALUResultM(ALUResultM),
                        .ReadDataM(ReadDataM),
                        .RdM(RdM),
                        .PCPlus4M(PCPlus4M),
                        .RegWriteW(RegWriteW),
                        .ResultSrcW(ResultSrcW),
                        .ALUResultW(ALUResultW),
                        .ReadDataW(ReadDataW),
                        .RdW(RdW),
                        .PCPlus4W(PCPlus4W),
                        .FlushW(FlushW)
                       );
endmodule
