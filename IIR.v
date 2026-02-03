`timescale 1ns / 1ps

module sawtooth(input clk, input reset, output [7:0]out);
  reg [7:0]q=0;

  always@(posedge clk or posedge reset)begin
    if(reset) q<=0;
    else q<=q+1;
  end

  assign out=q;
endmodule

module IIR(input clk, input reset, input [7:0]x, output [7:0]y);
  reg [7:0]w0,w1=0;
  reg [7:0]q=0;
  always@(posedge clk or posedge reset)begin
    if(reset)begin
      w1<=0;
      q<=0;
    end
    else begin
      w0=x+w1;
      q<=w0+w1;
      w1<=w0;
    end
  end
  assign y=q;
endmodule

module top(input clk, input reset, output [7:0]x, output [7:0]y, output [7:0]y_iir);
  sawtooth S1(clk,reset,x);
  IIR I1(clk,reset,x,y_iir);
endmodule
