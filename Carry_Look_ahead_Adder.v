// P_i = A_i ^ B_i      (Propagate: P_i is 1 if carry is propagated through bit i)
// G_i = A_i & B_i      (Generate: G_i is 1 if carry is generated at bit i)
// Sum_i = P_i ^ C_i

// C1 = G0 + P0 & C0
// C2 = G1 + P1 & G0 + P1 & P0 & C0
// C3 = G2 + P2 & G1 + P2 & P1 & G0 + P2 & P1 & P0 & C0
// C4 = G3 + P3 & G2 + P3 & P2 & G1 + P3 & P2 & P1 & G0 + P3 & P2 & P1 & P0 & C0

// Augmenting the 4-bit CLA to compute block propagate and generate signals.
// the p_block and g_block are made from the same logic as C4, but without C0.
// p_block = P3 & P2 & P1 & P0
// g_block = G3 + P3 & G2 + P3 & P2 & G1 + P3 & P2 & P1 & G0

module cla_4bit(a, b, c_in, sum, c_out, p_block, g_block);
    input [3:0] a, b;
    input c_in;
    output [3:0] sum;
    output c_out, p_block, g_block;

    wire [3:0] p, g;
    wire c1, c2, c3;

    assign g = a & b;
    assign p = a ^ b;

    assign c1 = g[0] | (p[0] & c_in);
    assign c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c_in);
    assign c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c_in);
    assign c_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c_in);

    assign sum[0] = p[0] ^ c_in;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;

    assign p_block = p[0] & p[1] & p[2] & p[3];
    assign g_block = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

endmodule


