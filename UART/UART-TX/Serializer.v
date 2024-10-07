module Serializer #( parameter WIDTH = 8 )(
input  [WIDTH-1:0] P_DATA,
input  Data_Valid,
input  ser_en, clk, rst,
output reg ser_done,
output reg ser_data
	);

reg [3:0] counter ;

always @(*) begin
	if (!ser_en) begin
		ser_data <= 1;
    end
	else  begin
		ser_data <= P_DATA [counter];
	end
end

always @(posedge clk or negedge rst) begin
	if (!rst ) begin
		counter <= 0;
		ser_done <= 0;
	end
	else if (Data_Valid) begin
		counter <= 0;
		ser_done <= 0;
	end
	else if (ser_en && (counter == 7)) begin
		ser_done <= 1;
		counter <= 0;
	end
    else begin
		counter <= counter + 1 ;
		ser_done <= 0;
	end
end
endmodule
