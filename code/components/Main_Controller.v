module Main_Controller (
    input  [6:0]                   opcode,
    output                         RegWrite, MemWrite, ALUSrcA, ALUSrcB, UseRs1, UseRs2, JALR, Branch, Jump,
    output [1:0]                   ResultSrc, ALUOp,
    output [2:0]                   ImmSrc
);

    reg [15:0] control ;

    assign {Branch, Jump, RegWrite, MemWrite, ALUSrcA, ALUSrcB, UseRs1, UseRs2, JALR, ResultSrc, ImmSrc, ALUOp} = control ;

    always @(*) begin
        casex (opcode)    
            7'b0000000: control = 16'b_0_0_0_0_0_0_0_0_0_00_000_00 ; // bubble / flushed instruction
            7'b0000011: control = 16'b_0_0_1_0_0_1_1_0_0_01_000_00 ; // lw
            7'b0100011: control = 16'b_0_0_0_1_0_1_1_1_0_xx_001_00 ; // sw
            7'b011x011: control = 16'b_0_0_1_0_0_0_1_1_0_00_xxx_10 ; // R (x=1 W instr, x=0 instr is I type)
            7'b001x011: control = 16'b_0_0_1_0_0_1_1_0_0_00_000_11 ; // I 
            7'b1100011: control = 16'b_1_0_0_0_0_0_1_1_0_xx_010_xx ; // Br  
            7'b1101111: control = 16'b_0_1_1_0_0_0_0_0_0_10_011_xx ; // JAL
            7'b1100111: control = 16'b_0_1_1_0_0_1_1_0_1_10_000_00 ; // JALR
            7'b0110111: control = 16'b_0_0_1_0_0_1_0_0_0_11_100_xx ; // LUI 
            7'b0010111: control = 16'b_0_0_1_0_1_1_0_0_0_00_100_00 ; // AUIPC
            default: control = 16'b_x_x_x_x_x_x_x_x_x_xx_xxx_xx ;
        endcase
    end
    
endmodule