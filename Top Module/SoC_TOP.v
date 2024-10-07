`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2024 11:30:52 PM
// Design Name: 
// Module Name: SoC_TOP
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


module SoC_TOP(clk,rst,RX,TX);

    //declaration of I/O's
    input  clk,rst;
    input  RX;
    output TX;
    
    //declaration of internal wires
    // proc to master wires
    wire        transEn,proc_write,proc_ready;
    wire [31:0] proc_addr,proc_wdata,proc_rdata;
    
    //master to bus decoder wires
    wire        PSEL,PENABLE,PWRITE;
    wire [31:0] PADDR,PWDATA;
    
    //decoder to peripheral wires
    wire PSEL1;
    // UART to master wires
    wire PREADY;
    wire [31:0] PRDATA;
    //declare RV32I
    RV32I Processor (
                     // inputs
                     .clk(clk),
                     .rst(rst),
                     .proc_rdata(proc_rdata),
                     .proc_ready(proc_ready),
                     .PENABLE(PENABLE),
                     // outputs
                     .transEn(transEn),
                     .proc_write(proc_write),
                     .proc_addr(proc_addr),
                     .proc_wdata(proc_wdata)
                 );
                 
    //declare APB Masster
    APB_Master APB_Master(
                          //master interface//
                          
                          // inputs
                          .PCLK(clk),
                          .PRESETn(rst),
                          .transEn(transEn),
                          .proc_write(proc_write),
                          .proc_addr(proc_addr),
                          .proc_wdata(proc_wdata), 
                          // outputs
                          .proc_rdata(proc_rdata),
                          .proc_ready(proc_ready), 
                          
                          //slave interface//
                          
                          // outputs
                          .PSEL(PSEL),
                          .PENABLE(PENABLE),
                          .PWRITE(PWRITE),
                          .PADDR(PADDR),
                          .PWDATA(PWDATA), 
                          //inputs
                          .PRDATA(PRDATA),
                          .PREADY(PREADY)
                          );
                 
    //declare address decoder
    addr_decoder addr_dec (
                           .PSEL(PSEL),
                           .PADDR(PADDR),
                           .PSEL1(PSEL1) 
                           );
    
    //declare UART peripheral
    UART UART (
               //APB inputs
               .PCLK(clk),
               .PRESETn(rst),
               .PADDR(PADDR),
               .PWDATA(PWDATA),
               .PWRITE(PWRITE),
               .PSEL(PSEL1),
               .PENABLE(PENABLE), 
               //APB outputs
               .PREADY(PREADY),
               .PRDATA(PRDATA), 
               //Slave input
               .RX(RX), 
               //Slave output
               .TX(TX) 
                );
endmodule
