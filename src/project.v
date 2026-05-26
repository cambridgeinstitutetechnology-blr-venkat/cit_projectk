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
    wire [7:0] mix;

    // FORCE strong connectivity (important for OpenROAD density)
    assign mix = ui_in ^ uio_in ^ {8{ena}} ^ {8{clk}} ^ {8{rst_n}};

    wire feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3] ^ mix[2];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            lfsr <= 8'hA5 ^ mix;
        else if (ena)
            lfsr <= {lfsr[6:0], feedback} ^ mix;
    end

    // OUTPUT must be strongly driven & mixed
    assign uo_out = lfsr ^ mix;

    assign uio_out = lfsr | mix;
    assign uio_oe  = 8'h00;

endmodule

`default_nettype wire
