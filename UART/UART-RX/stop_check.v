module stop_check (
input  sampled_bit,
input  stp_chk_en,
output reg stp_err
	);
always @(*) begin
	if (stp_chk_en) begin
	 if (!sampled_bit) 
		 stp_err <= 'b1;
	else 
	     stp_err <= 'b0;
end
else stp_err <= 'b0;
end
endmodule