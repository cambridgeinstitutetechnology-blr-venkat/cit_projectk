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
    reg [7:0] mix;
    reg [7:0] temp;

    wire feedback;

    // force input usage (improves synthesis stability)
    always @(posedge clk) begin
        if (ena) begin
            mix  <= ui_in ^ uio_in;
            temp <= mix ^ {lfsr[6:0], lfsr[7]};
        end
    end

    // LFSR feedback
    assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

    // main sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            lfsr <= 8'hA5;
        else if (ena)
            lfsr <= temp ^ {lfsr[6:0], feedback};
    end

    assign uo_out = lfsr ^ mix;

    assign uio_out = mix;
    assign uio_oe  = 8'b0;

endmodule

`default_nettype wire
