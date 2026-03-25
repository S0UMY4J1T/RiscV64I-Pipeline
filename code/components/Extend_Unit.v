module Extend_Unit #(
    parameter DATA_BUS_WIDTH = 64
) ( 
    input      [31 : 0]               Instr,
    input      [2:0]                  ImmSrc,
    output reg [DATA_BUS_WIDTH-1 : 0] ImmExt
);
    always @(*) begin
        casex (ImmSrc)
            3'b000: ImmExt = { {52{Instr[31]}} , Instr[31:20]};  // I type
            3'b001: ImmExt = { {52{Instr[31]}} , Instr[31:25] , Instr[11:7] }; // S type
            3'b010: ImmExt = { {51{Instr[31]}} , Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0}; // B type
            3'b011: ImmExt = { {43{Instr[31]}} , Instr[31], Instr[19:12], Instr[20], Instr[30:21], 1'b0}; // J type
            3'b100: ImmExt = { {32{Instr[31]}} , Instr[31:12] , 12'b0 }; // U type
            default: ImmExt = 64'bx;
        endcase 
    end
    
endmodule