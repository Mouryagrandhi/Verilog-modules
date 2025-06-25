module JohnsonCounter(input CLK, output reg [3:0] Q=0); 

  always @(posedge CLK) begin 

      Q[0] <= Q[1]; 

      Q[1] <= Q[2]; 

      Q[2] <= Q[3]; 

      Q[3] <= ~ Q[0]; 

  end 

endmodule 
