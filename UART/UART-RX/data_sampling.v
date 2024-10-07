module data_sampling (
input clk, rst,
input data_samp_en,
input RX_IN,
input [5:0] prescale,
input [3:0] edge_cnt,
output reg sampled_bit
	);
reg samp1, samp2, samp3;

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		samp1 <=0;
		samp2 <=0;
		samp3 <=0;
	end
	else if (data_samp_en) begin
    if (edge_cnt == ((prescale >> 1)- 2))
	samp1 <= RX_IN;
	else if (edge_cnt == ((prescale >> 1)- 1))
	samp2 <= RX_IN;
	else if (edge_cnt == ((prescale >> 1)))
	samp3 <= RX_IN;
end
end

always @(posedge clk or negedge rst) begin
	if (!rst) 
    sampled_bit <= 0 ;		
	else if (edge_cnt == ((prescale >> 1)+ 1)) 
	sampled_bit <= (samp1 & samp2) | (samp2 & samp3) |(samp1 & samp3);
end

endmodule