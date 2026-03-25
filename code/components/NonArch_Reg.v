module NonArch_Reg #(
    parameter DATA_BUS_WIDTH    = 64
) (
    input                             clk, en, reset,
    input      [DATA_BUS_WIDTH-1 : 0] data,
    output reg [DATA_BUS_WIDTH-1 : 0] out
);

    always @(posedge clk ) begin
        if (reset) out <= 0;
        else out <= (en)? data : out;
    end
    
endmodule