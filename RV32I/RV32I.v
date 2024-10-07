`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2024 05:47:38 AM
// Design Name: 
// Module Name: RV32I
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


module RV32I(clk,rst,proc_rdata,proc_ready,PENABLE, // inputs
             transEn,proc_write,proc_addr,proc_wdata // outputs
             );

    //declaration of I/O's
    input         clk,rst;
    input         proc_ready,PENABLE;
    input  [31:0] proc_rdata;
    output        transEn,proc_write;
    output [31:0] proc_addr;
    output [31:0] proc_wdata;
    
    //declaration of internal wires
    
    // Hazard Unit outputs
    wire        StallF,StallD,StallE,StallM,FlushD,FlushE,FlushW;
    wire [1:0]  ForwardAE,ForwardBE;
    //Fetch cycle inputs
    wire        PCSrcE;
    // Decode cycle inputs
    wire [31:0] instrD,PCD,PCPlus4D;
    //Execute cycle inputs
    wire        RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE;
    wire [1:0]  ResultSrcE, MemSizeE;
    wire [3:0]  ALUCtrlE;
    wire [4:0]  Rs1E,Rs2E,RdE;
    wire [31:0] RD1E,RD2E,PCE,ExtImmE,PCPlus4E;
    //Memory inputs
    wire        RegWriteM,MemWriteM,IsPerM;
    wire [1:0]  ResultSrcM, MemSizeM;
    wire [4:0]  RdM;
    wire [31:0] ALUResultM,WriteDataM,PCPlus4M,PCTargetE;
    //WriteBack inputs
    wire        RegWriteW;
    wire [1:0]  ResultSrcW;
    wire [4:0]  RdW;
    wire [31:0] ALUResultW,ReadDataW,PCPlus4W;
    //WriteBack output
    wire [31:0] ResultW;
    
    
    
    //////////// HAZARD UNIT ////////////
    hazard_unit Hazard_Unit (
                             //inputs
                             .Rs1D(instrD[19:15]),
                             .Rs2D(instrD[24:20]),
                             .Rs1E(Rs1E),
                             .Rs2E(Rs2E),
                             .RdE(RdE),
                             .PCSrcE(PCSrcE),
                             .ResultSrcE0(ResultSrcE[0]),
                             .RdM(RdM),
                             .RegWriteM(RegWriteM),
                             .RdW(RdW),
                             .RegWriteW(RegWriteW),
                             .proc_ready(proc_ready),
                             .PENABLE(PENABLE),
                             .IsPerM(IsPerM), 
                             //outputs
                             .StallF(StallF),
                             .StallD(StallD),
                             .StallE(StallE),
                             .StallM(StallM),
                             .FlushD(FlushD),
                             .FlushE(FlushE),
                             .FlushW(FlushW),
                             .ForwardAE(ForwardAE),
                             .ForwardBE(ForwardBE)
                            );
    
    //////////// FETCH CYCLE ////////////
    fetch_cycle Fetch (
                       //inputs
                       .clk(clk),
                       .rst(rst),
                       .pcTargetE(PCTargetE),
                       .pcSrcE(PCSrcE),
                       //outputs
                       .instrD(instrD),
                       .pcD(PCD),
                       .pc_plus4D(PCPlus4D),
                       //Hazard unit input
                       .StallF(StallF),
                       .StallD(StallD),
                       .FlushD(FlushD)
                       );
                       
    
       //////////// DECODE CYCLE //////////// 
       decode_cycle Decode (
                            //inputs
                            .clk(clk),
                            .rst(rst),
                            .instrD(instrD),
                            .pcD(PCD),
                            .pc_plus4D(PCPlus4D), 
                            // write back signals
                            .RegWriteW(RegWriteW),
                            .RdW(RdW),
                            .ResultW(ResultW), 
                            // Hazard unit input
                            .StallE(StallE),
                            .FlushE(FlushE), 
                            //Control output signals
                            .RegWriteE(RegWriteE),
                            .ResultSrcE(ResultSrcE),
                            .MemWriteE(MemWriteE),
                            .JumpE(JumpE),
                            .BranchE(BranchE),
                            .ALUCtrlE(ALUCtrlE),
                            .ALUSrcE(ALUSrcE),
                            .MemSizeE(MemSizeE), 
                            //outputs
                            .RD1E(RD1E),
                            .RD2E(RD2E),
                            .pcE(PCE),
                            .Rs1E(Rs1E),
                            .Rs2E(Rs2E),
                            .RdE(RdE),
                            .ExtImmE(ExtImmE),
                            .pc_plus4E(PCPlus4E)
                            ); 
               
       //////////// Execute CYCLE ////////////
       execute_cycle Execute (
                              .clk(clk),
                              .rst(rst),
                              //control inputs
                              .RegWriteE(RegWriteE),
                              .ResultSrcE(ResultSrcE),
                              .MemWriteE(MemWriteE),
                              .JumpE(JumpE),
                              .BranchE(BranchE),
                              .ALUCtrlE(ALUCtrlE),
                              .ALUSrcE(ALUSrcE),
                              .ExtImmE(ExtImmE),
                              .MemSizeE(MemSizeE),
                              // inputs
                              .RD1E(RD1E),
                              .RD2E(RD2E),
                              .PCE(PCE),
                              .Rs1E(Rs1E),
                              .Rs2E(Rs2E),
                              .RdE(RdE),
                              .PCPlus4E(PCPlus4E),
                              .ResultW(ResultW), 
                              // hazard unit signals
                              .StallM(StallM),
                              .ForwardAE(ForwardAE),
                              .ForwardBE(ForwardBE), 
                              // outputs
                              .RegWriteM(RegWriteM),
                              .ResultSrcM(ResultSrcM),
                              .MemWriteM(MemWriteM),
                              .MemSizeM(MemSizeM),
                              .ALUResultM(ALUResultM),
                              .WriteDataM(WriteDataM),
                              .RdM(RdM),
                              .PCPlus4M(PCPlus4M),
                              .PCTargetE(PCTargetE), // sent to Fetch
                              .PCSrcE(PCSrcE), // sent to Fetch
                              .IsPerM(IsPerM),
                              .transEn(transEn)
                             );
                             
       //////////// Memory CYCLE ////////////
       memory_cycle Memory (
                            //control inputs
                            .RegWriteM(RegWriteM),
                            .ResultSrcM(ResultSrcM),
                            .MemWriteM(MemWriteM),
                            .MemSizeM(MemSizeM), 
                            // inputs
                            .clk(clk),
                            .rst(rst),
                            .ALUResultM(ALUResultM),
                            .WriteDataM(WriteDataM),
                            .RdM(RdM),
                            .PCPlus4M(PCPlus4M),
                            .IsPerM(IsPerM),
                            .proc_rdata(proc_rdata),
                            // hazard unit signals
                            .FlushW(FlushW),
                            // outputs
                            .RegWriteW(RegWriteW), //sent to decode
                            .ResultSrcW(ResultSrcW),
                            .ALUResultW(ALUResultW),
                            .ReadDataW(ReadDataW),
                            .RdW(RdW), //sent to decode
                            .PCPlus4W(PCPlus4W) 
                           );
                           
    //////////// WRITE BACK CYCLE ////////////
    writeback_cycle Write_Back (
                                //control inputs
                                .RegWriteW(RegWriteW),
                                .ResultSrcW(ResultSrcW), 
                                //inputs
                                .ALUResultW(ALUResultW),
                                .ReadDataW(ReadDataW),
                                .RdW(RdW),
                                .PCPlus4W(PCPlus4W), 
                                //output
                                .ResultW(ResultW) //sent to decode & execute
                           );
                           
                           
    // assign outputs
    
    assign proc_write = MemWriteM;
    assign proc_addr = ALUResultM;
    assign proc_wdata = WriteDataM;
     
endmodule
