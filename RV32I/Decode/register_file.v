`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2024 11:39:37 AM
// Design Name: 
// Module Name: register_file
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


module register_file(clk,A1,A2,A3,WD3,WE3,RD1,RD2);

    input clk,WE3;
    input [4:0] A1,A2,A3;
    input [31:0] WD3;
    output [31:0] RD1,RD2;
    
    reg [31:0] reg_file [0:31];
    
    initial reg_file[0] = 0;
        
    always @(negedge clk) begin
        if(WE3) reg_file[A3] <= WD3;
    end
    assign RD1 = reg_file [A1];
    assign RD2 = reg_file [A2];
endmodule
