module parity_check (
input clk,rst,
input  [7:0] P_DATA,
input  sampled_bit,
input  PAR_TYP,
input  par_chk_en, done_chk,
output reg par_err
	);
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		par_err <= 'b0;		
	end
	else if (par_chk_en) begin
	if   (PAR_TYP && (sampled_bit == ~(^P_DATA)) ) 
        par_err <= 'b0;
        else if (!PAR_TYP && (sampled_bit == (^P_DATA)) )
        par_err <= 'b0;
        else 
        par_err <= 'b1;
    end  	
end

always @(posedge clk or negedge rst) begin
	if (!rst) begin
	par_err <= 'b0;	
	end
	else if (done_chk) begin
	par_err <= 'b0;	
	end
end

endmodule