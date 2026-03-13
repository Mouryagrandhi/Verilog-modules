// Q1.18 Signed Fixed-Point Adder
//
// Q Format Review:
//   Q1.18 = 1 sign bit + 1 integer bit + 18 fractional bits = 20 bits total
//   Range: -2.0 to (2.0 - 2^-18)
//
// When adding two signed Q1.18 numbers, one extra integer bit is needed to
// hold the carry and prevent overflow.
//   Q1.18 + Q1.18 => Q2.18
//   Q2.18 = 1 sign bit + 2 integer bits + 18 fractional bits = 21 bits total
//   Range: -4.0 to (4.0 - 2^-18)
//
// Implementation: both inputs are sign-extended to 21 bits before addition.

`timescale 1ns / 1ps

module q1_18_adder (
    input  signed [19:0] a,    // Q1.18 operand (20 bits)
    input  signed [19:0] b,    // Q1.18 operand (20 bits)
    output signed [20:0] sum   // Q2.18 result  (21 bits)
);
    // Sign-extend both operands to 21 bits then add.
    // The extra MSB prevents overflow and preserves the correct Q2.18 result.
    assign sum = {{1{a[19]}}, a} + {{1{b[19]}}, b};

endmodule


// Testbench
module q1_18_adder_tb;

    reg  signed [19:0] a, b;
    wire signed [20:0] sum;

    // Scale factor: 2^18 = 262144
    real scale;
    initial scale = 262144.0;

    q1_18_adder uut (.a(a), .b(b), .sum(sum));

    task check;
        input signed [19:0] op_a;
        input signed [19:0] op_b;
        input signed [20:0] expected;
        begin
            a = op_a;
            b = op_b;
            #1;
            if (sum !== expected)
                $display("FAIL: a=%0d b=%0d  sum=%0d (expected %0d)", op_a, op_b, sum, expected);
            else
                $display("PASS: %.6f + %.6f = %.6f  [raw: %0d + %0d = %0d]",
                         $itor(op_a) / scale,
                         $itor(op_b) / scale,
                         $itor(sum)  / scale,
                         op_a, op_b, sum);
        end
    endtask

    initial begin
        $display("=== Q1.18 Signed Adder Testbench ===");
        $display("Resultant Q format: Q1.18 + Q1.18 = Q2.18 (21 bits)\n");

        // 0.5 + 0.5 = 1.0  (2^17 + 2^17 = 2^18)
        check(20'sh20000, 20'sh20000, 21'sh40000);

        // 0.5 + (-0.5) = 0.0
        check(20'sh20000, -20'sh20000, 21'sh00000);

        // -1.0 + (-1.0) = -2.0  (within Q2.18 range)
        check(-20'sh40000, -20'sh40000, -21'sh80000);

        // 1.9999961853... (max positive Q1.18) + 0.0 = same value
        check(20'sh7FFFF, 20'sh00000, 21'sh7FFFF);

        // Negative + Positive: -0.75 + 0.25 = -0.5
        // -0.75 * 262144 = -196608 = 20'hD0000 (signed)
        //  0.25 * 262144 =  65536  = 20'h10000
        // -0.5  * 262144 = -131072 = 21'hFFE00000 ... raw = -131072
        check(-20'sh30000, 20'sh10000, -21'sh20000);

        $display("\nDone.");
        $finish;
    end

endmodule
