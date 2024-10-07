`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2024 01:35:34 AM
// Design Name: 
// Module Name: control_unit
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


module control_unit(op,funct3,funct7,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUCtrl,Jump,MemSize);

    //declaration of I/O's
    input [6:0] op;
    input [2:0] funct3;
    input funct7;
    output Branch, Jump, MemWrite, ALUSrc, RegWrite;
    output [1:0] ResultSrc, ImmSrc, MemSize;
    output [3:0] ALUCtrl;
    
    //declaration of internal wires
    wire [1:0] ALUop;
    
    //declare main decoder
    main_decoder MainDec (
                          .opcode(op), 
                          .funct3(funct3), 
                          .Branch(Branch),
                          .Jump(Jump), 
                          .ResultSrc(ResultSrc), 
                          .MemWrite(MemWrite), 
                          .ALUSrc(ALUSrc), 
                          .ImmSrc(ImmSrc), 
                          .MemSize(MemSize), 
                          .RegWrite(RegWrite), 
                          .ALUop(ALUop)
                          );
                          
    //declare ALU decoder
    alu_decoder ALUDec (
                        .ALUop(ALUop), 
                        .funct3(funct3), 
                        .funct7_5(funct7), 
                        .op5(op[5]), 
                        .ALUCtrl(ALUCtrl)
                        );
                        

endmodule
