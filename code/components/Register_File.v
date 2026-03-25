module Register_File #(
    parameter REG_ADR_BUS_WIDTH = 5,
    parameter DATA_BUS_WIDTH    = 64,
    parameter XLEN              = 32
) (
    input                            clk, WE3,
    input  [REG_ADR_BUS_WIDTH-1 : 0] A1, A2, A3,
    input  [DATA_BUS_WIDTH-1 : 0]    WD3,
    output [DATA_BUS_WIDTH-1 : 0]    RD1 , RD2 
);
    reg [XLEN-1 : 0] register_file [DATA_BUS_WIDTH-1 : 0] ;

    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            register_file[i] = 0;
        end
    end

    assign RD1 = (A1 == 0) ? 64'd0 : register_file[A1] ;
    assign RD2 = (A2 == 0) ? 64'd0 : register_file[A2] ;

    always @(posedge clk) begin
        if (A3 == 0) register_file[A3] <= 64'b0;
        else register_file[A3] <= (WE3)? WD3 : register_file[A3] ;
    end
    
endmodule