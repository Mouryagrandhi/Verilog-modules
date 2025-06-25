module seq_110_moore(
    input clk,
    input reset,    // active-high synchronous reset
    input x,
    output y        // high when "110" is detected
);

    parameter S0=2'd0, S1=2'd1, S2=2'd2, S3=2'd3;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            S0: next_state=(x)?S1:S0;
            S1: next_state=(x)?S2:S0;
            S2: next_state=(x)?S2:S3;
            S3: next_state=(x)?S1:S0;
            default: next_state=S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state<=S0;
        else
            state<=next_state;
    end

    assign y=(state==S3);

endmodule
