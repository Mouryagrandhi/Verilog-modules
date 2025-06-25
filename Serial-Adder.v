`timescale 1ns/1ns 

 

module serial_adder (input CLK, input Reset, input X, input Y, output reg Z = 0); 

reg C = 0; 

always @(posedge CLK or negedge Reset) begin 

  if (Reset==0) begin 

    {C,Z}=2'b00; 

  end 

  else begin 

    {C,Z}=X+Y+C; 

  end 

end                   

endmodule 

 

//Testbench 

module SA_tb(); 

reg CLK=0, Reset=1, X=0, Y=0; 

wire Z; 

always begin #5 CLK = ~CLK; end 

initial begin 

   #1 Reset = 0; 

   #5 Reset = 1; 

   #14 X = 1; Y = 0; 

   #10 X = 0; Y = 1; 

   #10 X = 1; Y = 1; 

end 

serial_adder sa (.CLK(CLK), .Reset(Reset), .X(X), .Y(Y), .Z(Z)); 

endmodule
