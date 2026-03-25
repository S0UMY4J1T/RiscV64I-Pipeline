module Forwarding_Unit #(
    parameter REG_ADR_BUS_WIDTH = 5,
    parameter DATA_BUS_WIDTH    = 64
) (
    input [REG_ADR_BUS_WIDTH-1 : 0] A1E, A2E, RdM, RdW,
    input                           RegW_M, RegW_W,
    output reg  [1:0]              ForwardAE, ForwardBE
);

    always @(*) begin
        //ForwardAE
        if ((RdM != 0) && (RegW_M && (RdM == A1E))) ForwardAE = 2'b01 ;
        else if ((RdW != 0) && (RegW_W &&(RdW == A1E))) ForwardAE = 2'b10 ;
        else ForwardAE = 2'b00 ;
    
        //ForwardBE
        if ((RdM != 0) && (RegW_M && (RdM == A2E))) ForwardBE = 2'b01 ;
        else if ((RdW != 0) && (RegW_W && (RdW == A2E))) ForwardBE = 2'b10 ;
        else ForwardBE = 2'b00 ;
    end

    
endmodule