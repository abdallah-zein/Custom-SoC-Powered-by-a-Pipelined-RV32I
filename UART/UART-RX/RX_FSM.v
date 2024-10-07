module RX_FSM (
input clk, rst,
input RX_IN,
input PAR_EN,
input [3:0] bit_cnt,
input par_err,
input strt_glitch,
input stp_err,
input [5:0] prescale,
input [5:0] edge_cnt,
output reg enable, new_frame,
output reg data_samp_en,
output reg par_chk_en,
output reg strt_chk_en,
output reg stp_chk_en,
output reg done_chk,
output reg data_valid,
output reg deser_en
	);
reg bit_max;

reg [2:0] cs, ns;

localparam  [2:0]    idle      = 3'b000,
                     start_bit = 3'b001,
                     ser_data  = 3'b010,
					      par_bit   = 3'b011,
					      stop_bit  = 3'b100;


always @(posedge clk or negedge rst) begin
	if (!rst) begin
		cs <= idle;	
	end
	else begin
		cs <= ns;
	end
end

always @(*) begin
	case (cs)
         idle     : if (RX_IN == 0)
                    ns <= start_bit;
                    else 
                    ns <= idle;
                        
         start_bit: if ((bit_cnt == 'b1) && !strt_glitch)
                    ns <= ser_data;
                    else if ((bit_cnt == 'b1) && strt_glitch)
                    ns <= idle;
                    else
                    ns <= start_bit;

         ser_data : if ((bit_cnt == 'b1001) && PAR_EN)
                    ns <= par_bit;
                    else if ((bit_cnt == 'b1001) && !PAR_EN)
                    ns <= stop_bit;
                    else
                    ns <= ser_data;

         par_bit:  if ((bit_cnt == 'b1010))
                    ns <= stop_bit;
                    else
                    ns <= par_bit;

         stop_bit:  if (bit_cnt == 'b0)
                    ns <= idle; 
                    else
                    ns <= stop_bit;


         default  : ns <= idle;

	endcase
end

always @(*) begin
                     enable       <= 'b0;
                     data_samp_en <= 'b0;
                     par_chk_en   <= 'b0;
                     strt_chk_en  <= 'b0;
                     stp_chk_en   <= 'b0;
                     data_valid   <= 'b0;
                     deser_en     <= 'b0;
                     new_frame    <= 'b0;
                     done_chk     <= 'b0;
	case (cs)
         idle     : begin
               	  if (RX_IN == 0) begin
         	        enable       <= 'b1;
                    data_samp_en <= 'b1;
                    new_frame    <= 'b1;
                    end
                    
                    else begin
                    enable       <= 'b0;
                    data_samp_en <= 'b0;
                    new_frame    <= 'b0;
                    end
                    end


         start_bit: begin
                    if ((edge_cnt == prescale) && (bit_cnt == 'b0))
                    begin
                    data_samp_en <= 'b1;
                    enable <= 'b1;
                    strt_chk_en <=  'b1;
                    end
                    else begin
                    data_samp_en <= 'b1;
                    enable <= 'b1;
                    strt_chk_en <= 'b0;
                    end
                    end

         ser_data: begin
                    data_samp_en <= 'b1;
                    enable       <= 'b1;
                    if ((edge_cnt == prescale -2 ))
                    deser_en <= 'b1;
                    end  

         par_bit:   begin
         			  if ((edge_cnt == prescale -1 ) && (bit_cnt == 'b1001))
                    begin
                    data_samp_en <= 'b1;
                    enable <= 'b1;
                    par_chk_en <=  'b1;
                    end
                    else begin
                    data_samp_en <= 'b1;
                    enable <= 'b1;
                    par_chk_en <=  'b0;  
                    end
                    end

         stop_bit:  begin
                    if ((edge_cnt == prescale -1 ) && bit_max)
                    begin
                    data_samp_en <= 'b1;
                    enable <= 'b1;
                    stp_chk_en <= 'b1;
                    done_chk <= 'b1;
                    end 
                    else begin
                    data_samp_en <= 'b1;
                    enable <= 'b1;
                    stp_chk_en <= 'b0;
                    done_chk <= 'b0;
                    end

                    if ((edge_cnt == prescale - 1) && bit_max && !par_err && !stp_err)
                    begin
                    data_samp_en <= 'b1;
                    enable <= 'b1;
                    data_valid <= 'b1;	
                    end 
                    else if ((edge_cnt == prescale) && bit_max)
                    begin
                    data_samp_en <= 'b1;
                    enable <= 'b1;
                    data_valid <= 'b0; 
                    end 
                    else begin
                    data_samp_en <= 'b1;
                    enable <= 'b1;
                    data_valid <= 'b0;    
                    end
                    end

         default  :  begin
                     enable       <= 'b0;
                     data_samp_en <= 'b0;
                     par_chk_en   <= 'b0;
                     strt_chk_en  <= 'b0;
                     stp_chk_en   <= 'b0;
                     data_valid   <= 'b0;
                     deser_en     <= 'b0;
                     end

	endcase
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