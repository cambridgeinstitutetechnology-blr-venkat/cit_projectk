`default_nettype none

module tt_um_sandy_venky dut  (
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
    wire [7:0] mix;

    // use inputs
    assign mix = ui_in ^ uio_in;

    // x^8 + x^6 + x^5 + x^4 + 1
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

    assign uo_out  = lfsr ^ mix;
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule

`default_nettype wire
