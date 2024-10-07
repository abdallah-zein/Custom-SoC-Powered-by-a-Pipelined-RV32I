module FSM (
input clk,rst,	
input Data_Valid,
input par_en,
input ser_done,
output reg ser_en, busy,
output reg [2:0] mux_sel
	);

localparam  [2:0]    idle      = 3'b000,
                     start_bit = 3'b001,
                     ser_data  = 3'b010,
					 par_bit   = 3'b011,
					 stop_bit  = 3'b100;

					 
					 
reg [2:0] cs, ns;

always @(posedge clk or negedge rst) begin
	if (!rst) begin
	cs <= idle ;
	end

	else begin
		cs <= ns ;
	end
end

always @(*) begin
	case (cs)
    	idle     : if (Data_Valid) 
    		       ns <= start_bit;
    	           else 
    		       ns <= idle;
    	
    	start_bit: ns <= ser_data;

    	ser_data : if (ser_done && par_en) 
    		       ns <= par_bit;
    	           else if (ser_done && (!par_en))
    		       ns <= stop_bit;
    		       else
    		       ns <= ser_data;

    	par_bit  : ns <= stop_bit;

    	stop_bit : ns <= idle;
    	            
        default  : ns <= idle;
	endcase
end

always @(*) begin
    busy = 1'b1;
	case (cs)
    	idle     : begin
                   mux_sel = 3'b000;
                   busy = 1'b0;
                   end
    	
    	start_bit: mux_sel = 3'b001;

    	ser_data : begin
    	           mux_sel = 3'b010;
    	           ser_en  = 1'b1;
                   end

    	par_bit  : mux_sel = 3'b011;

    	stop_bit : mux_sel = 3'b100;
    	            
        default  : begin
                   mux_sel = 3'b000;
                   busy = 1'b0;
                   end
	endcase
end
endmodule