`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2024 04:42:33 PM
// Design Name: 
// Module Name: main_decoder
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


module main_decoder(opcode, funct3, Branch, Jump, ResultSrc, MemWrite, ALUSrc, ImmSrc, MemSize, RegWrite, ALUop);

    input [6:0] opcode;
    input [2:0] funct3;
    output Branch, Jump, MemWrite, ALUSrc, RegWrite;
    output [1:0] ResultSrc, ImmSrc, ALUop;
    output reg [1:0] MemSize;
    
    // LB & SB --> MemSize= 2'b01
    // LH & SH --> MemSize= 2'b10
    // LW & SW --> MemSize= 2'b11
    
    reg [10:0] controles;
    assign {RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUop,Jump}=controles;

    always @(*) begin
        MemSize=2'b00;
        case(opcode)
        7'b0000011: begin // LOAD
            controles = 11'b1_00_1_0_01_0_00_0;
            case(funct3)
            0: MemSize= 2'b01; //LOAD BYTE
            1: MemSize= 2'b10; // LOAD HALF WORD
            default: MemSize= 2'b11; // LOAD WORD
            endcase
        end
        7'b0100011: begin // STORE
            controles = 11'b0_01_1_1_xx_0_00_0;
            case(funct3)
            0: MemSize= 2'b01; // STORE BYTE
            1: MemSize= 2'b10; // STORE HALF WORD
            default: MemSize= 2'b11; // STORE WORD
            endcase
        end
        7'b0110011: controles = 11'b1_xx_0_0_00_0_10_0; // R-TYPE
        7'b1100011: controles = 11'b0_10_0_0_xx_1_01_0; // beq
        7'b0010011: controles = 11'b1_00_1_0_00_0_10_0; // I-TYPE
        7'b1101111: controles = 11'b1_11_x_0_10_0_xx_1; // jal
        default:    controles = 0;      
        endcase
    end
endmodule
