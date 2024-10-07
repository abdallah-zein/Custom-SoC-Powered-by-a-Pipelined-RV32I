module deserializer (
input clk,rst,
input  sampled_bit,
input  deser_en,
output reg [7:0] P_DATA
	);
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		P_DATA <= 'b0 ;
		
	end
	else if (deser_en) begin
		P_DATA <= {sampled_bit, P_DATA [7:1]} ;
	end
end

endmodule