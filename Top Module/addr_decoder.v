`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2024 08:21:07 AM
// Design Name: 
// Module Name: addr_decoder
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


module addr_decoder(PSEL,PADDR,PSEL1);
    //declare I/O's
    input        PSEL;
    input [31:0] PADDR;
    output reg   PSEL1;
    always @(*) begin
        PSEL1 = 0; // SLAVE ADDRESS RANGE 0X0200 --> 0X11FF
        if (PSEL)
            if (PADDR >= 32'h00000200 && PADDR <= 32'h000011ff)
                PSEL1 = 1;
    end
endmodule
