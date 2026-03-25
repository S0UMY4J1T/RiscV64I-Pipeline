module Top_Module #(
    parameter DATA_BUS_WIDTH    = 64,
    parameter INSTR_WIDTH = 32
) (
    input                         clk, reset,
    input                         Ext_MemWrite,
    input  [DATA_BUS_WIDTH-1 : 0] Ext_WriteData, Ext_DataAdr,
    output                        WE,
    output [DATA_BUS_WIDTH-1 : 0] WD_DataMem, A_DataMem, RD_DataMem,
    output [DATA_BUS_WIDTH-1 : 0] PC,PCD, PCE, PCM, PCW, Result

);
    wire WE_rv64;
    wire [DATA_BUS_WIDTH-1 : 0] WD_DataMem_rv64, ALUResult;
    wire [INSTR_WIDTH-1 : 0] Instr, InstrM ;

    assign A_DataMem = reset ? Ext_DataAdr : ALUResult;
    assign WD_DataMem = (Ext_MemWrite && reset) ? Ext_WriteData : WD_DataMem_rv64 ;
    assign WE  = (Ext_MemWrite && reset) ? 1 : WE_rv64;


    RiscV_CPU name1 (clk, reset, Instr, RD_DataMem, WE_rv64, InstrM, PC,PCD, PCE, PCM, PCW, Result, ALUResult, WD_DataMem_rv64);
    Instruction_Mem name2 (PC, Instr);
    Data_mem name3 (clk, WE, InstrM[14:12], A_DataMem, WD_DataMem, RD_DataMem);
    
endmodule
