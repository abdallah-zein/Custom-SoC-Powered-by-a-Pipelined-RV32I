`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2024 08:11:48 PM
// Design Name: 
// Module Name: UART
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


module UART(PCLK,PRESETn,PADDR,PWDATA,PWRITE,PSEL,PENABLE, //APB inputs
            PREADY,PRDATA, //APB outputs
            RX, //Slave inputs
            TX //Slave outputs
            );
    
    //declaration of I/O's
    input             PCLK,PRESETn,PWRITE,PSEL,PENABLE;
    input             RX;
    input      [31:0] PADDR;
    input      [31:0] PWDATA;
    output            PREADY;
    output            TX;     
    output reg [31:0] PRDATA;
    
    //declaration of internal wires and registers
    ///// RX /////
    wire data_valid,Stop_Error,Parity_Error;
    wire PAR_EN,PAR_TYP;
    wire [5:0] prescale;
    wire [7:0] RX_DATA;
    ///// TX /////
    wire Data_Valid_TX;
    wire busy;
    wire [7:0] TX_DATA;
    
    assign Data_Valid_TX = PWRITE & (PADDR[3:0] == 4'h8) & PSEL & PENABLE; 
    assign PREADY = (PWRITE & (PADDR[3:0] == 4'h8) & busy & PSEL & PENABLE)? 0: 1; 
    
    //declare UART memory
    reg [7:0] control_reg; //offset 0 --> control reg
    reg [3:0] status_reg;  //offset 4 --> status reg
    reg [7:0] tx_reg;      //offset 8 --> tx data reg
    reg [7:0] rx_reg;      //offset c --> rx data reg
    
    //control
    assign prescale = control_reg[5:0];
    assign PAR_EN = control_reg[6];
    assign PAR_TYP = control_reg[7];
    //TX data
    assign TX_DATA = tx_reg; 
    
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
        control_reg <= 0;
        status_reg <= 0;
        tx_reg <= 0;
        rx_reg <= 0;
        end
        else if (PSEL)
        case(PADDR[3:0])
            4'h0: begin // control (WRITE_ONLY)
                if (PWRITE && PENABLE) begin
                    control_reg <= PWDATA[7:0];
                    end
                end 
            4'h4: begin // status (READ_ONLY)
                if(!PWRITE) begin                    
                    status_reg[0] <= Stop_Error;
                    status_reg[1] <= Parity_Error;
                    status_reg[2] <= data_valid;
                    status_reg[3] <= busy;
                    PRDATA [3:0] <= status_reg;
                    end
                end
            4'h8: begin // TX data (WRITE_ONLY)
                if (PWRITE && PENABLE) begin
                    tx_reg <= PWDATA[7:0];
                    end
                end
            4'hc: begin // RX data (READ_ONLY)
                if(!PWRITE) begin
                    rx_reg <= RX_DATA;
                    PRDATA [7:0] <= rx_reg;
                    end
                end
        endcase
    end
    
    //declare RX
    UART_RX_TOP UART_RX (
                         .clk(PCLK),
                         .rst(PRESETn),
                         .RX_IN(RX),
                         .PAR_EN(PAR_EN),
                         .PAR_TYP(PAR_TYP),
                         .prescale(prescale),
                         .data_valid(data_valid),
                         .Stop_Error(Stop_Error),
                         .Parity_Error(Parity_Error),
                         .P_DATA(RX_DATA)
                         );
                         
    UART_TOP #(.WIDTH(8)) UART_TX (
                                   .clk(PCLK),
                                   .rst(PRESETn),
                                   .P_DATA(TX_DATA),
                                   .par_en(PAR_EN),
                                   .Data_Valid(Data_Valid_TX),
                                   .PAR_TYP(PAR_TYP),
                                   .busy(busy),
                                   .TX_OUT(TX)
                                   );
endmodule
