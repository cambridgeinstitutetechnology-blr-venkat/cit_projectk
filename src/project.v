/*
 * Copyright (c) 2026 K Vishnu
 * SPDX-License-Identifier: Apache-2.0
 */

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

    reg [7:0] shift_reg;
    wire feedback;

    // LFSR feedback (max-length style polynomial)
    assign feedback = shift_reg[7] ^ shift_reg[5] ^ shift_reg[4] ^ shift_reg[3];

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= 8'h01;
        else if (ena)
            shift_reg <= {shift_reg[6:0], feedback};
    end

    // Output LFSR value
    assign uo_out = shift_reg;

    // Disable bidirectional IOs
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Proper unused signal handling
    wire _unused_ok = &{ui_in, uio_in};

endmodule

`default_nettype wire
