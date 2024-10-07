`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024 06:00:29 PM
// Design Name: 
// Module Name: APB_Master
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


module APB_Master(
                  //master interface
                  PCLK,PRESETn,transEn,proc_write,proc_addr,proc_wdata, // inputs
                  proc_rdata,proc_ready, // outputs
                  //slave interface
                  PSEL,PENABLE,PWRITE,PADDR,PWDATA, // outputs
                  PRDATA,PREADY //inputs
                 );
                 
    //declare I/O's
    //// master interface ////
    input             PCLK,PRESETn,transEn,proc_write;
    input      [31:0] proc_addr;
    input      [31:0] proc_wdata;
    output reg        proc_ready;
    output     [31:0] proc_rdata;
    //// salve interface ////
    input             PREADY;
    input      [31:0] PRDATA;
    output reg        PSEL,PENABLE;
    output            PWRITE;
    output     [31:0] PADDR;
    output     [31:0] PWDATA;
    
    //APB state definition 
    localparam [1:0] idle   = 2'b00,
                     setup  = 2'b01,
                     access = 2'b10; 
                     
    reg [1:0] state, next_state;
    
    //Main APB FSM
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn)
            state <= idle;
        else
            state <= next_state;
    end 
    
    assign PWRITE     = proc_write;
    assign PADDR      = proc_addr;
    assign PWDATA     = proc_wdata;
    assign proc_rdata = PRDATA;
    
    always @(*) begin
        //defult signals
        PSEL       = 0;
        PENABLE    = 0;
        proc_ready = 1; 
        
        next_state = idle; //defult next state
        
        case (state)
            idle: begin
                if(transEn)
                    next_state = setup;
                else 
                    next_state = idle;
            end
            
            setup: begin
                PSEL    = 1;
                PENABLE = 0;
                
                next_state = access;
            end
            
            access: begin
                PSEL=1;
                PENABLE=1;
                if(PREADY) begin
                    next_state = idle;
                    proc_ready = 1;
                end    
                else 
                    next_state = access;
            end
        
        endcase
    end
    
    
endmodule
