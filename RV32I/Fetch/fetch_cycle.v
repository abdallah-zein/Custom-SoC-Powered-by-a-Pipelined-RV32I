`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2024 10:59:22 PM
// Design Name: 
// Module Name: fetch_cycle
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


module fetch_cycle(clk, rst, pcTargetE, pcSrcE, instrD, pcD, pc_plus4D, StallF, StallD,FlushD);

    // declaration of I/O's 
    input clk,rst;
    input pcSrcE; // ctrl signal
    input StallF, StallD, FlushD; // Hazads signals
    input [31:0] pcTargetE;
    output [31:0] instrD, pcD, pc_plus4D;
    
    //declaration of internal wires
    wire [31:0] pc_nxt, pc_cur, pc_plus4F;
    wire [31:0] instrF;
    
    //declare PC MUX
    assign pc_nxt = (pcSrcE== 1'b0)? pc_plus4F : pcTargetE;
    
    //declare PC
    pc program_counter (
                        .pc_nxt(pc_nxt),
                        .pc_cur(pc_cur),
                        .clk(clk),
                        .rst(rst),
                        .StallF(StallF)
                        );
    
    //declare instruction memomry
    inst_mem instr_mem (
                        .pc_addres(pc_cur),
                        .inst(instrF)
                        );
    
    //declare PC adder
    adder pc_adder (
                    .in_a(pc_cur),
                    .in_b(32'h00000004),
                    .out(pc_plus4F)
                    );
    
    //declare Fetch-Decode Register
    FET_DEC_Reg F_D_Reg (
                         .instrF(instrF),
                         .instrD(instrD),
                         .pcF(pc_cur),
                         .pcD(pcD),
                         .pc_plus4F(pc_plus4F),
                         .pc_plus4D(pc_plus4D),
                         .StallD(StallD),
                         .FlushD(FlushD),
                         .clk(clk),
                         .rst(rst)
                         );
    

endmodule
