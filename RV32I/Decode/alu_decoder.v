`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2024 12:55:35 AM
// Design Name: 
// Module Name: alu_decoder
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


module alu_decoder(ALUop, funct3, funct7_5, op5, ALUCtrl);
    input [1:0] ALUop;
    input funct7_5, op5;
    input [2:0] funct3;
    output reg [3:0] ALUCtrl;
    
    localparam      add=0,
                    sub=1,
                    AND=2,
                    OR=3,
                    XOR=4,
                    slt=5,
                    sltu=6,
                    sll=7,
                    srl=8,
                    sra=9;
                    
    always @(*) begin
        ALUCtrl=0;
        case(ALUop)
        0: ALUCtrl = add; //load or store
        1: ALUCtrl = sub; //beq
        2: begin
                case(funct3)
                0: ALUCtrl = (funct7_5 & op5)? sub:add;
                1: ALUCtrl = sll;
                2: ALUCtrl = slt;
                3: ALUCtrl = sltu;
                4: ALUCtrl = XOR;
                5: ALUCtrl = funct7_5? sra:srl;
                6: ALUCtrl = OR;
                7: ALUCtrl = AND;
                endcase
           end 
        endcase
    end
        
endmodule
