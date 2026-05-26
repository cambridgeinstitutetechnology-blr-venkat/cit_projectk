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
    reg [7:0] input_reg;
    wire feedback;

    // CAPTURE INPUTS INTO REGISTER (important for placement stability)
    always @(posedge clk) begin
        if (ena)
            input_reg <= ui_in ^ uio_in;
    end

    // CLEAN LFSR
    assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            lfsr <= 8'h1;
        else if (ena)
            lfsr <= {lfsr[6:0], feedback} ^ input_reg;
    end

    assign uo_out = lfsr;

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule

`default_nettype wire
