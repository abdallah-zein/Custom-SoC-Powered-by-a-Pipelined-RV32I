module Parity_Calc  #( parameter WIDTH = 8 )(
input  [WIDTH-1:0] P_DATA,
input PAR_TYP, Data_Valid,
output reg par_bit
	);

always @(*) begin
	if (Data_Valid) begin
		if (PAR_TYP) 
        par_bit = ~(^P_DATA);
        else 
        par_bit = ^(P_DATA);
	end
end

endmodule