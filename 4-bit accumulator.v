`timescale 1ns / 1ps

module dff_async(d, q, clk, rst);
    input d, clk, rst;
    output q;
    reg q=0;
    always@(posedge clk or posedge rst)
    begin
        if(rst) q <= 1'b0;
        else
            q <= d;
    end
endmodule

module half_adder(a, b, sum, carry_out);
    input a, b;
    output sum, carry_out;
    assign sum = a ^ b;
    assign carry_out = a & b;
endmodule

module full_adder(a, b, carry_in, sum, carry_out);
    input a, b, carry_in;
    output sum, carry_out;
    wire sum_ha1, carry_ha1; 
    wire sum_ha2, carry_ha2;
    half_adder ha1 (.a(a), .b(b), .sum(sum_ha1), .carry_out(carry_ha1));
    half_adder ha2 (.a(sum_ha1), .b(carry_in), .sum(sum), .carry_out(carry_ha2));
    assign carry_out = carry_ha1 | carry_ha2;
endmodule

module accumulator(clk, rst, in_bit, acc_out_0, acc_out_1, acc_out_2, acc_out_3);
    input clk, rst, in_bit;
    output acc_out_0, acc_out_1, acc_out_2, acc_out_3;

    wire add_sum_0, add_sum_1, add_sum_2, add_sum_3; 
    wire carry_out_0, carry_out_1, carry_out_2, carry_out_3; 
    wire dff_out_0, dff_out_1, dff_out_2, dff_out_3; 
    wire carry_in_0 = 1'b0;

    full_adder fa_0(.a(dff_out_0), .b(in_bit), .carry_in(carry_in_0), .sum(add_sum_0), .carry_out(carry_out_0));
    full_adder fa_1(.a(dff_out_1), .b(1'b0), .carry_in(carry_out_0), .sum(add_sum_1), .carry_out(carry_out_1));
    full_adder fa_2(.a(dff_out_2), .b(1'b0), .carry_in(carry_out_1), .sum(add_sum_2), .carry_out(carry_out_2));
    full_adder fa_3(.a(dff_out_3), .b(1'b0), .carry_in(carry_out_2), .sum(add_sum_3), .carry_out(carry_out_3));

    dff_async dff_0(.d(add_sum_0), .q(dff_out_0), .clk(clk), .rst(rst));
    dff_async dff_1(.d(add_sum_1), .q(dff_out_1), .clk(clk), .rst(rst));
    dff_async dff_2(.d(add_sum_2), .q(dff_out_2), .clk(clk), .rst(rst));
    dff_async dff_3(.d(add_sum_3), .q(dff_out_3), .clk(clk), .rst(rst));
    assign acc_out_0 = dff_out_0;
    assign acc_out_1 = dff_out_1;
    assign acc_out_2 = dff_out_2;
    assign acc_out_3 = dff_out_3;

endmodule
