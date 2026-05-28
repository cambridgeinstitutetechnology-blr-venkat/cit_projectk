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

    // Use ALL input bits
    wire [7:0] mixed_inputs;
    assign mixed_inputs = ui_in ^ uio_in;

    // LFSR feedback
    assign feedback =
        lfsr[7] ^
        lfsr[5] ^
        lfsr[4] ^
        lfsr[3] ^
        mixed_inputs[0] ^
        mixed_inputs[1] ^
        mixed_inputs[2] ^
        mixed_inputs[3] ^
        mixed_inputs[4] ^
        mixed_inputs[5] ^
        mixed_inputs[6] ^
        mixed_inputs[7];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            lfsr <= 8'h01;
        else if (ena)
            lfsr <= {lfsr[6:0], feedback};
    end

    assign uo_out  = lfsr;
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule

`default_nettype wire
