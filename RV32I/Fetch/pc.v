`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2024 03:39:13 PM
// Design Name: 
// Module Name: pc
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


module pc(pc_cur, pc_nxt, clk, rst, StallF);

    input clk, rst;
    input StallF; // undeveloped fetch stall signal from the hazard control module
    input [31:0] pc_nxt;
    output reg [31:0] pc_cur;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) pc_cur <= 0;
        else if (StallF==0) pc_cur <= pc_nxt;
    end
    
endmodule
