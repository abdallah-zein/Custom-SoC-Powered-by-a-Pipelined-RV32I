module UART_RX_TOP (
input clk, rst,
input RX_IN,
input PAR_EN,
input PAR_TYP,
input [5:0] prescale,
output wire data_valid,
output wire Stop_Error,
output wire Parity_Error,
output wire [7:0] P_DATA
	);

wire [3:0] bit_cnt;
wire [5:0] edge_cnt;
wire enable;
wire new_frame;
wire data_samp_en;
wire par_chk_en;
wire strt_chk_en;
wire stp_chk_en;
wire done_chk;
wire deser_en;
wire sampled_bit;
wire strt_glitch;


RX_FSM RX_FSM (.clk(clk), .rst(rst), .RX_IN(RX_IN), .PAR_EN(PAR_EN), .bit_cnt(bit_cnt), .par_err(Parity_Error),
            .stp_err(Stop_Error), .strt_glitch(strt_glitch), .prescale(prescale), .edge_cnt(edge_cnt),
            .enable(enable), .new_frame(new_frame), .data_samp_en(data_samp_en), .par_chk_en(par_chk_en), .strt_chk_en(strt_chk_en),
            .stp_chk_en(stp_chk_en), .done_chk(done_chk), .deser_en(deser_en), .data_valid(data_valid));

edge_bit_counter U0_edge_bit_counter (.clk(clk), .rst(rst), .prescale(prescale), .edge_cnt(edge_cnt),
                                      .enable(enable), .new_frame(new_frame), .PAR_EN(PAR_EN), .bit_cnt(bit_cnt));

data_sampling UO_data_sampling (.clk(clk), .rst(rst), .RX_IN(RX_IN), .data_samp_en(data_samp_en), .prescale(prescale), 
	                            .edge_cnt(edge_cnt), .sampled_bit(sampled_bit));

parity_check U0_parity_check(.clk(clk), .rst(rst), .P_DATA(P_DATA), .sampled_bit(sampled_bit), .PAR_TYP(PAR_TYP),
                             .par_chk_en(par_chk_en), .done_chk(done_chk), .par_err(Parity_Error) );  

stop_check U0_stop_check (.sampled_bit(sampled_bit), .stp_chk_en(stp_chk_en), .stp_err(Stop_Error));


strt_check U0_strt_check (.clk(clk), .rst(rst), .sampled_bit(sampled_bit), .strt_chk_en(strt_chk_en), .strt_glitch(strt_glitch));

deserializer U0_deserializer (.clk(clk), .rst(rst), .sampled_bit(sampled_bit),.deser_en(deser_en),.P_DATA(P_DATA));

endmodule