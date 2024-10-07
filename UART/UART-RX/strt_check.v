module strt_check (
input  clk, rst,
input  sampled_bit,
input  strt_chk_en,
output reg strt_glitch
	);
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		strt_glitch <= 'b0;	
	end
	else if(strt_chk_en) begin 
	if (sampled_bit) 
		 strt_glitch <= 'b1;
	else 
	     strt_glitch <= 'b0;
end
else begin
	strt_glitch <= 'b0;
end
end
endmodule