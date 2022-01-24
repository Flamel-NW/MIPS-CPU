`include "ctrl_encode_def.v"
module MemExtender(ALUOut, op, din, dout);
    
	input  [1:0] ALUOut;
	input  [2:0] op;
	input  [31:0] din;
	output [31:0] dout;
	
	reg [31:0] dout;
	
	always @(*) begin
	    case (op)
		    `ME_LW : dout = din;
			`ME_LH : if(ALUOut[1] == 1'b1)
						dout = { { 16{ din[31] } } , din[31:16] };
					 else 
					    dout = { { 16{ din[15] } } , din[15:0] };
						
			`ME_LHU: if(ALUOut[1] == 1'b1)
						dout = {16'b0, din[31:16]};
					 else 
						dout = {16'b0, din[15:0]};
						
			`ME_LB : if(ALUOut == 2'b00)
						dout = { {24{din[7]} } , din[7:0]};
					 else if(ALUOut == 2'b01)
					    dout = { {24{din[15]} }, din[15:8]};
					 else if(ALUOut == 2'b10)
					    dout = { {24{din[23]} }, din[23:16]};
					 else if(ALUOut == 2'b11)
					    dout = { {24{din[31]} }, din[31:24]};
						
			`ME_LBU: if(ALUOut == 2'b00)
						dout = { 24'b0, din[7:0]};
					 else if(ALUOut == 2'b01)
					    dout = { 24'b0, din[15:8]};
					 else if(ALUOut == 2'b10)
					    dout = { 24'b0, din[23:16]};
					 else if(ALUOut == 2'b11)
					    dout = { 24'b0, din[31:24]};
		endcase
	end
	
endmodule




