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
    reg clk_reg;
    reg ena_reg;
    reg rst_reg;

    wire feedback;

    // REGISTER ALL CONTROL SIGNALS (IMPORTANT FOR PLACEMENT STABILITY)
    always @(posedge clk) begin
        clk_reg <= clk;
        ena_reg <= ena;
        rst_reg <= rst_n;
    end

    // CLEAN FEEDBACK
    assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

    // MAIN LOGIC
    always @(posedge clk_reg or negedge rst_reg) begin
        if (!rst_reg)
            lfsr <= 8'h01;
        else if (ena_reg)
            lfsr <= {lfsr[6:0], feedback} ^ ui_in ^ uio_in;
    end

    assign uo_out = lfsr;

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule

`default_nettype wire
