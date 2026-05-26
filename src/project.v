/*
 * Copyright (c) 2026 Satya Roop Bankuru
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

    assign feedback = shift_reg[7] ^ shift_reg[5] ^ shift_reg[4] ^ shift_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= 8'h01;
        else
            shift_reg <= {shift_reg[6:0], feedback};
    end

    assign uo_out = shift_reg;

    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    wire _unused = &{ena, ui_in, uio_in, 1'b0};

endmodule

