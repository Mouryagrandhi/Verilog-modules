`timescale 1ns / 1ps

module sawtooth(input clk, input reset, output [7:0]out);
  reg [7:0]q=0;

  always@(posedge clk or posedge reset)begin
    if(reset) q<=0;
    else q<=q+1;
  end

  assign out=q;
endmodule
