`include "ctrl_encode_def.v"

module becalc(ALUOut, op, be);
    input  [1:0] ALUOut;
	input  [1:0] op;
	output [3:0] be;
	reg [3:0] be;
	
	always @(*) begin
	    if(op == `BE_SW)
		    be = 4'b1111;
			
		else if(op == `BE_SH)
		    if(ALUOut[1] == 1'b1)
			    be = 4'b1100;
			else
			    be = 4'b0011;
				
		else if(op == `BE_SB)
		    if(ALUOut == 2'b00)
			    be = 4'b0001;
			else if(ALUOut == 2'b01)
			    be = 4'b0010;
			else if(ALUOut == 2'b10)
			    be = 4'b0100;
			else if(ALUOut == 2'b11)
			    be = 4'b1000;
			else
			    be = 4'b0000;
	end
endmodule
