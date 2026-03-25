module RiscV_CPU #(
    parameter DATA_BUS_WIDTH    = 64,
    parameter INSTR_WIDTH = 32
) (
    input                         clk, reset,
    input  [INSTR_WIDTH-1 : 0]    Instr,
    input  [DATA_BUS_WIDTH-1 : 0] RD_DataMem,
    output                        WE ,
    output [INSTR_WIDTH-1 : 0]    InstrM,
    output [DATA_BUS_WIDTH-1 : 0] PC ,PCD, PCE, PCM, PCW, Result, ALUResult, WD_DataMem
);

    wire [2:0] ALUControl, ImmSrc ;
    wire [1:0] ResultSrcE, ResultSrcW ;
    wire RegWriteM, RegWriteW, Condition, ALUSrcA, ALUSrcBE, UseRs1D, UseRs2D, JALR, PCSrc ;

    Control_Path name1 (clk, reset, Condition, StallD, FlushD, FlushE, Instr[30], Instr[14:12], Instr[6:0], RegWriteM, RegWriteW, WE, ALUSrcA,
                        ALUSrcBE, UseRs1D, UseRs2D, JALR, PCSrc, ResultSrcE, ResultSrcW, ImmSrc, ALUControl);
    Data_Path name2 (clk, reset, RegWriteM, RegWriteW, ALUSrcA, ALUSrcBE, UseRs1D, UseRs2D, JALR, PCSrc, ResultSrcE, ResultSrcW, ImmSrc, 
                     ALUControl, Instr, RD_DataMem, Condition, StallD, FlushD, FlushE, PC,PCD, PCE, PCM, PCW, Result, ALUResult, WD_DataMem, InstrM);
   
endmodule
