module Data_Path #(
    parameter REG_ADR_BUS_WIDTH = 5,
    parameter INSTR_WIDTH = 32,
    parameter DATA_BUS_WIDTH    = 64
) (
    input                         clk, reset, RegWriteM, RegWriteW, ALUSrcA, ALUSrcBE, UseRs1, UseRs2, JALR, PCSrc,
    input  [1:0]                  ResultSrcE, ResultSrcW,
    input  [2:0]                  ImmSrc, ALUControl,
    input  [INSTR_WIDTH-1 : 0]    InstrF,
    input  [DATA_BUS_WIDTH-1 : 0] RD_DataMemM,
    output                        Condition, StallD, FlushD, FlushE,
    output [DATA_BUS_WIDTH-1 : 0] PCF, PCD, PCE, PCM, PCW, Result, ALUResultM, WD_DataMem,
    output [INSTR_WIDTH-1 : 0]    InstrM
);

    wire                           StallF;
    wire [1:0]                     ForwardAE, ForwardBE;
    wire [REG_ADR_BUS_WIDTH-1 : 0] A1D, A2D, A1E, A2E, A3D, A3E, A3M, A3W;
    wire [INSTR_WIDTH-1 : 0]       InstrD, InstrE;
    wire [DATA_BUS_WIDTH-1 : 0]    WD3, SrcA, SrcB,
                                   RD1D, RD2D, RD1E, RD2E, RD1E_Fwd, RD2E_Fwd, RD2M,
                                   ImmExtD, ImmExtE, ImmExtM, ImmExtW,
                                   PCPlus4F, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W,
                                   PCPlusImmE, PCNextF, PCTargetE,
                                   ALUResultE, ALUResultW, RD_DataMemW;


    // Non Arch Registers
    NonArch_Reg#(INSTR_WIDTH) name12 (clk, StallD, reset|FlushD, InstrF, InstrD);
    NonArch_Reg name13 (clk, StallD, reset|FlushD, PCF, PCD);
    NonArch_Reg name14 (clk, StallD, reset|FlushD, PCPlus4F, PCPlus4D);
 
    NonArch_Reg name15 (clk, 1'b1, reset|FlushE, RD1D, RD1E);
    NonArch_Reg name16 (clk, 1'b1, reset|FlushE, RD2D, RD2E);
    NonArch_Reg#(INSTR_WIDTH) name17 (clk, 1'b1, reset|FlushE, InstrD, InstrE);
    NonArch_Reg name18 (clk, 1'b1, reset|FlushE, PCD, PCE);
    NonArch_Reg name19 (clk, 1'b1, reset|FlushE, ImmExtD, ImmExtE);
    NonArch_Reg name20 (clk, 1'b1, reset|FlushE, PCPlus4D, PCPlus4E);
    NonArch_Reg#(REG_ADR_BUS_WIDTH) name33 (clk, 1'b1, reset|FlushE, A1D, A1E);
    NonArch_Reg#(REG_ADR_BUS_WIDTH) name34 (clk, 1'b1, reset|FlushE, A2D, A2E);
    NonArch_Reg#(REG_ADR_BUS_WIDTH) name35 (clk, 1'b1, reset|FlushE, A3D, A3E);
     
    NonArch_Reg name21 (clk, 1'b1, reset, ALUResultE, ALUResultM);
    NonArch_Reg name22 (clk, 1'b1, reset, RD2E_Fwd, RD2M);
    NonArch_Reg name23 (clk, 1'b1, reset, PCPlus4E, PCPlus4M);
    NonArch_Reg name24 (clk, 1'b1, reset, ImmExtE, ImmExtM);
    NonArch_Reg name29 (clk, 1'b1, reset, PCE, PCM);
    NonArch_Reg#(REG_ADR_BUS_WIDTH) name31 (clk, 1'b1, reset, A3E, A3M);
    NonArch_Reg#(INSTR_WIDTH) name40 (clk, 1'b1, reset, InstrE, InstrM);
 
    NonArch_Reg name25 (clk, 1'b1, reset, ALUResultM, ALUResultW);
    NonArch_Reg name26 (clk, 1'b1, reset, RD_DataMemM, RD_DataMemW);
    NonArch_Reg name27 (clk, 1'b1, reset, PCPlus4M, PCPlus4W);
    NonArch_Reg name28 (clk, 1'b1, reset, ImmExtM, ImmExtW);
    NonArch_Reg name30 (clk, 1'b1, reset, PCM, PCW);
    NonArch_Reg#(REG_ADR_BUS_WIDTH) name32 (clk, 1'b1, reset, A3M, A3W);
    

    //PC Logic
    Adder name1 (PCF, 64'd4, PCPlus4F);
    Adder name3 (PCE, ImmExtE, PCPlusImmE);
    Mux2 name11 (JALR, PCPlusImmE, ALUResultE, PCTargetE);
    Mux2 name2 (PCSrc, PCPlus4F, PCTargetE, PCNextF);
    NonArch_Reg name4 (clk, StallF, reset, PCNextF, PCF);


    //Register Logic
    assign A1D = InstrD[19:15] ; 
    assign A2D = InstrD[24:20] ;
    assign A3D = InstrD[11:7] ;
    Register_File name5 (clk, RegWriteW, A1D, A2D, A3W, WD3, RD1D, RD2D);
    Mux4 name6 (ResultSrcW, ALUResultW, RD_DataMemW, PCPlus4W, ImmExtW, Result);
    assign WD3  = Result;

    //Extend Logic
    Extend_Unit name7 (InstrD, ImmSrc, ImmExtD);

    //ALU Logic
    Mux2 name10 (ALUSrcA, RD1E_Fwd, PCE, SrcA);
    Mux2 name9 (ALUSrcBE, RD2E_Fwd, ImmExtE, SrcB);
    ALU name8 (SrcA, SrcB, InstrE[14:12], InstrE[30], InstrE[3], ALUControl, Condition, ALUResultE);
    

    //DataMem Logic
    assign WD_DataMem = RD2M;  

    //Hazard Unit

    // Forwarding
    Mux3 name36 (ForwardAE, RD1E, ALUResultM, Result, RD1E_Fwd);
    Mux3 name37 (ForwardBE, RD2E, ALUResultM, Result, RD2E_Fwd);
    Forwarding_Unit name38 (A1E, A2E, A3M, A3W, RegWriteM, RegWriteW, ForwardAE, ForwardBE); 

    // Stalling and Flushing
    Stalling_Unit name39 (PCSrc, UseRs1, UseRs2, ResultSrcE, A1D, A2D, A3E, StallF, StallD, FlushD, FlushE);

    
endmodule
