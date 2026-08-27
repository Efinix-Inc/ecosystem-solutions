module pulse_sync (
    input  logic clk_in, rst_in, pulse_in,
    input  logic clk_out, rst_out,
    output logic pulse_out
);
    logic toggle_in, toggle_s1, toggle_s2, toggle_s3;

    // Toggle a signal in the source domain
    always_ff @(posedge clk_in or negedge rst_in) begin
        if (!rst_in) toggle_in <= 0;
        else if (pulse_in) toggle_in <= ~toggle_in;
    end

    // Synchronize to the destination domain
    always_ff @(posedge clk_out or negedge rst_out) begin
        if (!rst_out) begin
            toggle_s1 <= 0;
            toggle_s2 <= 0;
            toggle_s3 <= 0;
        end else begin
            toggle_s1 <= toggle_in;
            toggle_s2 <= toggle_s1;
            toggle_s3 <= toggle_s2;
        end
    end

    // Edge detect to recreate the pulse
    assign pulse_out = toggle_s2 ^ toggle_s3;
endmodule