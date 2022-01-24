module dm_4k( addr, din, be, DMWr, clk, dout );
   
   input  [11:2] addr;
   input  [31:0] din;
   input  [3:0]  be;		
   input         DMWr;
   input         clk;
   output [31:0] dout;
     
   reg [31:0] dmem[1023:0];
   
   always @(posedge clk) begin
      if (DMWr) begin
		  case (be)
			 // sw
			 4'b1111: dmem[addr] <= din;
			 // sh
			 4'b1100: dmem[addr][31:16] <= din[15:0];
			 4'b0011: dmem[addr][15:0]  <= din[15:0];
			 // sb	
			 4'b1000: dmem[addr][31:24] <= din[7:0];
			 4'b0100: dmem[addr][23:16] <= din[7:0];
			 4'b0010: dmem[addr][15:8]  <= din[7:0];
			 4'b0001: dmem[addr][7:0]   <= din[7:0];
			 default: ;
		  endcase
	  end
   end // end always
   
   assign dout = dmem[addr];
    
endmodule    
