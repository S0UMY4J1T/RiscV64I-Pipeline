
// instr_mem.v - instruction memory

module Instruction_Mem #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 64,
    parameter MEM_SIZE = 512
) (
    input       [ADDR_WIDTH-1:0] instr_addr,
    output      [DATA_WIDTH-1:0] instr
);

// array of 64 64-bit words or instructions
reg [DATA_WIDTH-1:0] instr_ram [0:MEM_SIZE-1];

initial begin
    // $readmemh("rv32i_book.hex", instr_ram);
    $readmemh("rv32i_test.hex", instr_ram);
end

// word-aligned memory access
// combinational read logic
assign instr = instr_ram[instr_addr[31:2]];

endmodule

