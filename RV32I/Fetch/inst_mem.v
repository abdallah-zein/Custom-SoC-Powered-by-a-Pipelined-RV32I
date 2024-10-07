`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2024 12:35:46 PM
// Design Name: 
// Module Name: inst_mem
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


module inst_mem(pc_addres, inst);
    input [31:0] pc_addres;
    output [31:0] inst;
    reg [31:0] mem [0:255];
    
    initial 
        $readmemh ("inst_memory.mem", mem);
        
    assign inst = mem[pc_addres[31:2]]; //word addressable 
    endmodule
