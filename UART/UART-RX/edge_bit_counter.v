module edge_bit_counter (
input clk , rst,
input enable, new_frame,
input PAR_EN,
input [5:0] prescale,
output reg [3:0] bit_cnt,
output reg [5:0] edge_cnt
	);
reg bit_max ;

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		bit_cnt  <= 'b0;
		edge_cnt <= 'b0;
	end
    else if (enable) begin
    if (!(edge_cnt == prescale) ) begin
		edge_cnt <= edge_cnt + 1 ;
		end

	else if ((edge_cnt == prescale) &&  !bit_max) begin
		edge_cnt <= 1 ;
		bit_cnt  <= bit_cnt + 1;
		end
	else if ((edge_cnt == prescale) &&  bit_max) begin
		edge_cnt <= 1 ;
		bit_cnt  <= 0 ;
		end
	end
	else begin
	edge_cnt <= 0 ;
	bit_cnt  <= 0 ;
    end
end

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		bit_cnt  <= 0 ;	
	end
	else if (new_frame) begin
	bit_cnt  <= 0 ;	
	end
end

always @(*) begin
	if (PAR_EN) begin

    if (bit_cnt == 'b1010)
    bit_max <= 1;
    else
    bit_max <= 0;

	end

	else begin
	if (bit_cnt == 'b1001)
    bit_max <= 1;
    else
    bit_max <= 0;	
	end
end


endmodule