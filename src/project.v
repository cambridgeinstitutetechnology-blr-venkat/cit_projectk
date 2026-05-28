`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    reg [7:0] lfsr;
    wire feedback;

    // Use ALL inputs
    wire [7:0] mix;
    assign mix = ui_in ^ uio_in;

    // LFSR feedback
    assign feedback =
        lfsr[7] ^
        lfsr[5] ^
        lfsr[4] ^
        lfsr[3] ^
        mix[0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            lfsr <= 8'h01;
        else if (ena)
            lfsr <= {lfsr[6:0], feedback};
    end

    // Use mix so nothing floats
    assign uo_out  = lfsr ^ mix;

    // Explicitly drive outputs
    assign uio_out = mix;
    assign uio_oe  = 8'hFF;

endmodule

`default_nettype wire
