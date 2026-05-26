module lfsr_8bit (
    input clk,
    input rst_n,
    output reg [7:0] uo_out
);

wire feedback;

assign feedback = uo_out[7] ^ uo_out[5] ^ uo_out[4] ^ uo_out[3];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        uo_out <= 8'b00000001;
    else
        uo_out <= {uo_out[6:0], feedback};
end

endmodule
