`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2024 01:02:43 AM
// Design Name: 
// Module Name: execute_cycle
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


module execute_cycle(clk,rst,RegWriteE,ResultSrcE,MemWriteE,JumpE,BranchE,ALUCtrlE,ALUSrcE,ExtImmE,MemSizeE, //control inputs
                     RD1E,RD2E,PCE,Rs1E,Rs2E,RdE,PCPlus4E,ResultW, // inputs
                     StallM,ForwardAE,ForwardBE, // hazard unit signals
                     RegWriteM,ResultSrcM,MemWriteM,MemSizeM,ALUResultM,WriteDataM,RdM,PCPlus4M,PCTargetE,PCSrcE,IsPerM,transEn // outputs
                     );
    
    //declaration of I/O's;
    input         clk,rst;
    input         RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE,StallM;
    input  [1:0]  ForwardAE, ForwardBE;
    input  [1:0]  ResultSrcE,MemSizeE;
    input  [3:0]  ALUCtrlE;
    input  [4:0]  Rs1E,Rs2E,RdE;
    input  [31:0] RD1E,RD2E,PCE,ExtImmE,PCPlus4E,ResultW;
    output        RegWriteM,MemWriteM,PCSrcE;
    output [1:0]  ResultSrcM, MemSizeM;
    output [4:0]  RdM;
    output [31:0] ALUResultM,WriteDataM,PCPlus4M,PCTargetE;
    
    output        transEn, IsPerM; //Flag to detect external periferals communication
    
    //declaration of internal wires
    wire        ZeroE;
    reg         IsPerE;
    reg  [31:0] SrcAE,SrcBE,SrcBE_WriteDataE;
    wire [31:0] WriteDataE,ALUResultE,ALUResultM_in;
    
    //declaration of MUX's & Periferal flag
    always @(*) begin
        SrcAE = 0;
        SrcBE = 0;
        SrcBE_WriteDataE = 0;
        IsPerE = 0;
        //SrcA 3x1 selection mux
        case (ForwardAE)
        0: SrcAE = RD1E;
        1: SrcAE = ResultW;
        2: SrcAE = ALUResultM_in;
        endcase
        
        //SrcB_WriteData 3x1 selection mux
        case (ForwardBE)
        0: SrcBE_WriteDataE = RD2E;
        1: SrcBE_WriteDataE = ResultW;
        2: SrcBE_WriteDataE = ALUResultM_in;
        endcase
        //SrcB 2x1 selection mux
        case (ALUSrcE)
        0: SrcBE = SrcBE_WriteDataE;
        1: SrcBE = ExtImmE;
        endcase
        
        //Periferal flag detection
        if ((ResultSrcE[0] || MemWriteE))
            if(ALUResultE > 511)
                IsPerE = 1;
        
    end 
    
    //declare ALU
    ALU ALU(
            .SrcA(SrcAE),
            .SrcB(SrcBE),
            .ALUResult(ALUResultE),
            .Zero(ZeroE),
            .ALUCtrl(ALUCtrlE)
            );
            
    //declare PC Target adder
    adder PCTargetAdder (
                         .in_a(PCE),
                         .in_b(ExtImmE),
                         .out(PCTargetE)
                         );
    
    //declare Execute-Memory Register 
    EXE_MEM_Reg E_M_Reg (
                         .clk(clk),
                         .rst(rst),
                         .RegWriteE(RegWriteE),
                         .ResultSrcE(ResultSrcE),
                         .MemWriteE(MemWriteE),
                         .MemSizeE(MemSizeE),
                         .ALUResultE(ALUResultE),
                         .WriteDataE(WriteDataE),
                         .RdE(RdE),
                         .PCPlus4E(PCPlus4E),
                         .RegWriteM(RegWriteM),
                         .ResultSrcM(ResultSrcM),
                         .MemWriteM(MemWriteM),
                         .MemSizeM(MemSizeM),
                         .ALUResultM(ALUResultM),
                         .WriteDataM(WriteDataM),
                         .RdM(RdM),
                         .PCPlus4M(PCPlus4M),
                         .IsPerM(IsPerM),
                         .IsPerE(IsPerE),
                         .StallM(StallM)
                         );
                         
    assign WriteDataE = SrcBE_WriteDataE;
    assign PCSrcE = (ZeroE & BranchE) | JumpE;
    assign ALUResultM_in = ALUResultM;
    assign transEn = IsPerE;
    
endmodule
