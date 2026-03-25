module Control_Path ( 
    input                          clk, reset, Condition, StallD, FlushD, FlushE,
    input                          funct7b5F,
    input  [2:0]                   funct3F,
    input  [6:0]                   opcodeF,
    output                         RegWriteM, RegWriteW, MemWriteM, ALUSrcAE, ALUSrcBE, UseRs1D, UseRs2D, JALRE, PCSrcE,
    output [1:0]                   ResultSrcE, ResultSrcW, 
    output [2:0]                   ImmSrcD, ALUControlE
);

    wire [6:0] opcodeD;
    wire [2:0] funct3D, ALUControlD;
    wire [1:0] ResultSrcD, ResultSrcM, ALUOpD;
    wire funct7b5D, RegWriteD, RegWriteE, MemWriteD, MemWriteE, ALUSrcAD, ALUSrcBD,
         JALRD, BranchD, BranchE, JumpD, JumpE;

    assign PCSrcE = (BranchE & Condition) | JumpE ; 

    // Non Arch Registers
    NonArch_Reg#(7) name3  (clk, StallD, reset|FlushD, opcodeF, opcodeD);
    NonArch_Reg#(1) name4  (clk, StallD, reset|FlushD, funct7b5F, funct7b5D);
    NonArch_Reg#(3) name5  (clk, StallD, reset|FlushD, funct3F, funct3D);
  
    NonArch_Reg#(1) name6  (clk, 1'b1, reset|FlushE, RegWriteD, RegWriteE);
    NonArch_Reg#(1) name7  (clk, 1'b1, reset|FlushE, MemWriteD, MemWriteE);
    NonArch_Reg#(1) name8  (clk, 1'b1, reset|FlushE, ALUSrcAD, ALUSrcAE);
    NonArch_Reg#(1) name9  (clk, 1'b1, reset|FlushE, ALUSrcBD, ALUSrcBE);
    NonArch_Reg#(1) name10 (clk, 1'b1, reset|FlushE, JALRD, JALRE);
    NonArch_Reg#(1) name11 (clk, 1'b1, reset|FlushE, BranchD, BranchE);
    NonArch_Reg#(1) name12 (clk, 1'b1, reset|FlushE, JumpD, JumpE);
    NonArch_Reg#(2) name13 (clk, 1'b1, reset|FlushE, ResultSrcD, ResultSrcE);
    NonArch_Reg#(3) name14 (clk, 1'b1, reset|FlushE, ALUControlD, ALUControlE);
    
    NonArch_Reg#(1) name15 (clk, 1'b1, reset, RegWriteE, RegWriteM);
    NonArch_Reg#(1) name16 (clk, 1'b1, reset, MemWriteE, MemWriteM);
    NonArch_Reg#(2) name17 (clk, 1'b1, reset, ResultSrcE, ResultSrcM);

    NonArch_Reg#(1) name18 (clk, 1'b1, reset, RegWriteM, RegWriteW);
    NonArch_Reg#(2) name19 (clk, 1'b1, reset, ResultSrcM, ResultSrcW);

    // Decoders
    Main_Controller name1 (opcodeD, RegWriteD, MemWriteD, ALUSrcAD, ALUSrcBD, UseRs1D, UseRs2D, JALRD, BranchD, JumpD, ResultSrcD, ALUOpD, ImmSrcD);
    ALU_Controller name2  (funct7b5D, ALUOpD, funct3D, ALUControlD);

endmodule