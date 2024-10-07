`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2024 05:49:36 AM
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit(Rs1D,Rs2D,Rs1E,Rs2E,RdE,PCSrcE,ResultSrcE0,RdM,RegWriteM,RdW,RegWriteW,proc_ready,PENABLE,IsPerM, //inputs
                   StallF,StallD,StallE,StallM,FlushD,FlushE,FlushW,ForwardAE,ForwardBE //outputs
                   );
                   
        input            PCSrcE,ResultSrcE0,RegWriteM,RegWriteW,proc_ready,PENABLE,IsPerM;
        input      [4:0] Rs1D,Rs2D,Rs1E,Rs2E,RdE,RdM,RdW;
        output reg       StallF,StallD,StallE,StallM,FlushD,FlushE,FlushW;
        output reg [1:0] ForwardAE,ForwardBE;
        
        reg lwStall,perStall;
        
        always @(*) begin
        
            if ((Rs1E==RdM) && RegWriteM && Rs1E!=0) ForwardAE = 2'b10; //Forwarding from Memory Stage
            else if ((Rs1E==RdW) && RegWriteW && Rs1E!=0) ForwardAE = 2'b01; //Forwarding from Write Back Stage
            else ForwardAE = 2'b00;
            
            if ((Rs2E==RdM) && RegWriteM && Rs2E!=0) ForwardBE = 2'b10; //Forwarding from Memory Stage
            else if ((Rs2E==RdW) && RegWriteW && Rs2E!=0) ForwardBE = 2'b01; //Forwarding from Write Back Stage
            else ForwardBE = 2'b00;
            
            //Stalling in lw instr
            lwStall = ResultSrcE0 & ((Rs1D==RdE) | (Rs2D==RdE));
            perStall = !proc_ready;
            perStall = IsPerM && (!PENABLE || !proc_ready);
            {FlushE,FlushD,StallD,StallF,StallE,StallM,FlushW} = {lwStall|PCSrcE,PCSrcE,lwStall|perStall,lwStall|perStall,perStall,perStall,perStall};
         end
         
         
         
endmodule
