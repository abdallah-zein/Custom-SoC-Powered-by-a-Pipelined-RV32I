`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2024 03:45:38 AM
// Design Name: 
// Module Name: data_memory
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

// memory width = 32
// memory depth = 512 (2^9)

module data_memory(clk,A,RD,WD,WE,MemSize);

    input         clk,WE;
    input  [1:0]  MemSize;
    input  [31:0] A,WD;
    output [31:0] RD;
    
    reg [31:0] data_mem[0:511];
    
    always @(negedge clk) begin
        if(WE) begin
            case(MemSize)
            1: data_mem[A[8:0]][7:0] <= WD[7:0];
            2: data_mem[A[8:0]][15:0] <= WD[15:0];
            default: data_mem[A[8:0]] <= WD;
            endcase
        end
    end
    
    assign RD = (MemSize==1)? {{24{data_mem[A[8:0]][7]}},data_mem[A[8:0]][7:0]}:
                (MemSize==2)? {{16{data_mem[A[8:0]][15]}},data_mem[A[8:0]][15:0]}:
                data_mem[A[8:0]];
    
    initial begin
        data_mem[0] = 32'h00000000;
    end
endmodule
