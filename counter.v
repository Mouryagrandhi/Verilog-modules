module counter (input CLK, input CLEAR, output reg [2:0] Q =0); 

  always @(posedge CLK or negedge CLEAR) begin 

    if (CLEAR == 0) begin 

       Q = 0; 

    end 

    else begin 

      Q = Q+1; 

    end 

  end 

endmodule 
