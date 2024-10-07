`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2024 03:50:29 PM
// Design Name: 
// Module Name: decode_cycle
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


module decode_cycle(clk,rst,instrD,pcD,pc_plus4D, //inputs
                    RegWriteW,RdW,ResultW, // write back signals
                    StallE,FlushE, // Hazard unit input
                    RegWriteE,ResultSrcE,MemWriteE,JumpE,BranchE,ALUCtrlE,ALUSrcE,MemSizeE, //Control output signals
                    RD1E,RD2E,pcE,Rs1E,Rs2E,RdE,ExtImmE,pc_plus4E); //outputs

    //declaration of I/O's
    input  clk,rst,RegWriteW,StallE,FlushE;
    input  [4:0] RdW;
    input  [31:0] instrD, pcD, pc_plus4D, ResultW;
    output [1:0] ResultSrcE, MemSizeE;
    output [3:0] ALUCtrlE;
    output [4:0] Rs1E,Rs2E,RdE;
    output [31:0] RD1E,RD2E,pcE,ExtImmE,pc_plus4E;
    output RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE;
    
    //declaration of internal wires
    wire        RegWriteD,MemWriteD,JumpD,BranchD,ALUSrcD;
    wire [1:0]  ResultSrcD, ImmSrcD, MemSizeD;
    wire [3:0]  ALUCtrlD;
    wire [31:0] RD1D,RD2D,PCD,ImmExtD;
    wire [4:0]  Rs1D,Rs2D,RdD;
    
    assign PCD  = pcD;
    assign Rs1D = instrD[19:15];
    assign Rs2D = instrD[24:20];
    assign RdD = instrD[11:7];
    
    //declare the control unit
    control_unit ControlUnit(
                             .op(instrD[6:0]),
                             .funct3(instrD[14:12]),
                             .funct7(instrD[30]),
                             .RegWrite(RegWriteD),
                             .ImmSrc(ImmSrcD),
                             .ALUSrc(ALUSrcD),
                             .MemWrite(MemWriteD),
                             .ResultSrc(ResultSrcD),
                             .Branch(BranchD),
                             .ALUCtrl(ALUCtrlD),
                             .Jump(JumpD),
                             .MemSize(MemSizeD)
                             );
                             
    //declare the register file
    register_file RegFile (
                           .clk(clk),
                           .A1(instrD[19:15]),
                           .A2(instrD[24:20]),
                           .A3(RdW),
                           .WD3(ResultW),
                           .WE3(RegWriteW),
                           .RD1(RD1D),
                           .RD2(RD2D)
                           );
                           
    //declare the extender
    imm_extend ImmExt (
                       .imm(instrD[31:7]), 
                       .immSrc(ImmSrcD), 
                       .immExt(ImmExtD)
                       );
                       
    //declare Decode-Execute Register
    DEC_EXC_Reg D_E_Reg (
                         .RegWriteD(RegWriteD),
                         .RegWriteE(RegWriteE),
                         .ResultSrcD(ResultSrcD),
                         .ResultSrcE(ResultSrcE),
                         .MemWriteD(MemWriteD),
                         .MemWriteE(MemWriteE),
                         .JumpD(JumpD),
                         .JumpE(JumpE),
                         .BranchD(BranchD),
                         .BranchE(BranchE),
                         .ALUCtrlD(ALUCtrlD),
                         .ALUCtrlE(ALUCtrlE),
                         .ALUSrcD(ALUSrcD),
                         .ALUSrcE(ALUSrcE),
                         .MemSizeD(MemSizeD),
                         .MemSizeE(MemSizeE),
                         .PCD(pcD),
                         .PCE(pcE),
                         .Rs1D(instrD[19:15]),
                         .Rs1E(Rs1E),
                         .Rs2D(instrD[24:20]),
                         .Rs2E(Rs2E),
                         .RdD(instrD[11:7]),
                         .RdE(RdE),
                         .ExtImmD(ImmExtD),
                         .ExtImmE(ExtImmE),
                         .PCPlus4D(pc_plus4D),
                         .PCPlus4E(pc_plus4E),
                         .StallE(StallE),
                         .FlushE(FlushE),
                         .RD1D(RD1D),
                         .RD1E(RD1E),
                         .RD2D(RD2D),
                         .RD2E(RD2E),
                         .clk(clk),
                         .rst(rst)
                         );
    
endmodule
