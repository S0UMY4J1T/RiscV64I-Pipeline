module Stalling_Unit #(
    parameter REG_ADR_BUS_WIDTH = 5,
    parameter DATA_BUS_WIDTH    = 64
) (
    input                           PCSrc, UseRs1, UseRs2,
    input [1:0]                     ResultSrcE,
    input [REG_ADR_BUS_WIDTH-1 : 0] A1D, A2D, RdE,
    output reg                      StallF, StallD, FlushD, FlushE
);

    always @(*) begin
        
        FlushD = PCSrc;

        if (ResultSrcE == 1 && ((UseRs1 && RdE == A1D) || (UseRs2 && RdE == A2D)) && RdE != 0) begin
            StallF = 0 ;
			StallD = 0 ;
            FlushE = 1 ; // PCSRC | LWStall(1)
        end
        else begin
            StallF = 1; 
			StallD = 1 ;
            FlushE = PCSrc ; // PCSRC | LWStall(0)
        end
    end
    
endmodule