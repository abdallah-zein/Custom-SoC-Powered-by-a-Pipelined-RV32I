`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2024 03:19:28 PM
// Design Name: 
// Module Name: ALU
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


module ALU(SrcA, SrcB, ALUResult, Zero, ALUCtrl);

    input [31:0] SrcA, SrcB;
    input [3:0] ALUCtrl;
    output reg [31:0] ALUResult;
    output Zero;
    
    assign Zero = (!(SrcA-SrcB))? 1 : 0;
    
    always @(*) begin
        ALUResult = 0;
        case(ALUCtrl)
        0:       ALUResult = SrcA + SrcB;                     //add
        1:       ALUResult = SrcA - SrcB;                     //sub
        2:       ALUResult = SrcA & SrcB;                     //bitwise AND
        3:       ALUResult = SrcA | SrcB;                     //bitwise OR
        4:       ALUResult = SrcA ^ SrcB;                     //bitwise XOR
        5:       ALUResult = SrcA < SrcB;                     // slt
        6:       ALUResult = ($signed(SrcA) < $signed(SrcB)); //sltu
        7:       ALUResult = SrcA << SrcB[4:0];               // sll
        8:       ALUResult = SrcA >> SrcB[4:0];               //srl
        9:       ALUResult = SrcA >>> SrcB[4:0];              //sra
        endcase
    end

endmodule
