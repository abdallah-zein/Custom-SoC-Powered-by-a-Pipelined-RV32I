module UART_TOP #( parameter WIDTH = 8 )(
input  [WIDTH-1:0] P_DATA,
input clk, rst,
input par_en, Data_Valid, PAR_TYP,
output  busy, TX_OUT
	);
wire ser_done, ser_en, par_bit, ser_data;
wire [2:0] mux_sel;

FSM U0_FSM (.clk(clk), .rst(rst), .Data_Valid(Data_Valid),.busy(busy), .ser_en(ser_en), .ser_done(ser_done), .mux_sel(mux_sel), .par_en(par_en));

Serializer U0_Serializer (.clk(clk), .rst(rst), .Data_Valid(Data_Valid), .P_DATA(P_DATA), .ser_en(ser_en), .ser_done(ser_done), .ser_data(ser_data) );

MUX U0_MUX (.mux_sel(mux_sel), .ser_data(ser_data), .par_bit(par_bit), .TX_OUT(TX_OUT) );

Parity_Calc U0_Parity_Calc (.Data_Valid(Data_Valid), .P_DATA(P_DATA), .PAR_TYP(PAR_TYP), .par_bit(par_bit) );

endmodule