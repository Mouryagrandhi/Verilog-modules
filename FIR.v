`timescale 1ns / 1ps

module sawtooth(input clk, input reset, output [7:0]out);
  reg [7:0]q=0;

  always@(posedge clk or posedge reset)begin
    if(reset) q<=0;
    else q<=q+1;
  end

  assign out=q;
endmodule

module delay(input clk, input [7:0]x, output [7:0]y);
  reg [7:0]d; 
  always@(posedge clk)begin
    d<=x;
  end
  assign y=d;
endmodule

module FIR(input clk, input reset, input[7:0]x, output [7:0]y);
  wire [7:0]d1,d2,d3;
  reg [7:0]p=0;
  
  delay D1(.clk(clk),.x(x),.y(d1));
  delay D2(.clk(clk),.x(d1),.y(d2));
  delay D3(.clk(clk),.x(d2),.y(d3));
  always@(posedge clk or posedge reset)begin
    if(reset)p<=0;
    else begin
      p<=((3*x) + (3*d1) + d2 + d3) >> 3;
    end
  end
  assign y=p;
endmodule

module top(input clk, input reset, output [7:0]x, output [7:0]y, output [7:0]y_iir);
  sawtooth S1(clk,reset,x);
  FIR F1(clk,reset,x,y);
endmodule
