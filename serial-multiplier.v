`timescale 1ns/1ns 

 

module Serial_Multiplier(input CLK, input Start, input [3:0] A, input [3:0] B, output reg [7:0] P, output Done); 

reg [2:0] count = 0; 

reg [3:0] M; 

always @(posedge CLK or negedge Start) begin 

  if(~Start) begin 

    M <= B; 

    count <= 3'd0; 

    P <= 8'd0; 

  end 

  else if(count<4) begin 

    P <= (P<<1) + {M[3]&A[3], M[3]&A[2], M[3]&A[1], M[3]&A[0]}; 

    M <= M<<1; 

    count <= count+1; 

  end 

end 

assign Done = (count==4); 

endmodule 

 

//Testbench 

module SM_tb(); 

reg CLK=0, Start=1; 

reg [3:0] A=2, B=14; 

wire [7:0] P; 

always begin #5 CLK = ~CLK; end 

initial begin 

   #1 Start = 0; 

   #5 Start = 1; 

end 

Serial_Multiplier sm(.CLK(CLK), .Start(Start), .A(A), .B(B), .P(P), .Done(Done)); 

endmodule 
