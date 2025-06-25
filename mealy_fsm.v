module seq_110_mealy(
    input clk,
    input reset,    // active-high synchronous reset
    input x,        // input sequence
    output wire y   // output goes high when "110" is detected
);

    parameter S0=2'd0, S1=2'd1, S2=2'd2, S3=2'd3;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            S0: next_state=(x)?S1:S0;
            S1: next_state=(x)?S2:S0;
            S2: next_state=(x==1'b0)?S0:S2;
            default: next_state=S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state<=S0;
        else
            state<=next_state;
    end

    assign y=(state==S2 && x==1'b0)?1'b1:1'b0;

endmodule
