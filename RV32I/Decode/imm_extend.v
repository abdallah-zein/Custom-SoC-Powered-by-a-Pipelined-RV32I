`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2024 01:24:45 PM
// Design Name: 
// Module Name: imm_extend
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


module imm_extend(imm, immSrc, immExt);
    input [24:0] imm;
    input [1:0] immSrc;
    output reg [31:0] immExt;
    
    always @(*) begin
        case(immSrc)
        0: immExt= {{20{imm[24]}}, imm[24:13]}; // I type
        1: immExt= {{20{imm[24]}}, imm[24:18], imm[4:0]}; // S type
        2: immExt= {{20{imm[24]}}, imm[0], imm[23:18], imm[4:1], 1'b0}; // B type
        3: immExt= {{12{imm[24]}}, imm[12:5], imm[13], imm[23:14], 1'b0}; // J type
        default: immExt=0;
        endcase
    end
endmodule
