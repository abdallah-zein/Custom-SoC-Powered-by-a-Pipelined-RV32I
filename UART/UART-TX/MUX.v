module MUX (
input [2:0] mux_sel,
input ser_data,
input par_bit,
output reg TX_OUT
	);
always @(*) begin
	case (mux_sel)
    3'b000: TX_OUT = 1;
    3'b001: TX_OUT = 0;
    3'b010: TX_OUT = ser_data;
    3'b011: TX_OUT = par_bit;
    3'b100: TX_OUT = 1;
	endcase

end
endmodule