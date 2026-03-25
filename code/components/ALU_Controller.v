module ALU_Controller #(
    parameter ADD = 3'b000,
    parameter SUB = 3'b001,
    parameter AND = 3'b010,
    parameter OR  = 3'b011,
    parameter XOR = 3'b100,
    parameter SLT = 3'b101,
    parameter SLL = 3'b110,
    parameter SR  = 3'b111
) (
    input            funct7b5,
    input      [1:0] ALUOp,
    input      [2:0] funct3,
    output reg [2:0] ALUControl
);

    always @(*) begin
        casex (ALUOp)
            2'b00: ALUControl = ADD;
            2'b01: ALUControl = SUB;
            2'b10: case (funct3)
                        3'b000: ALUControl = (funct7b5)? SUB : ADD ;
                        3'b001: ALUControl = SLL ;
                        3'b010: ALUControl = SLT ;
                        3'b011: ALUControl = SLT ;
                        3'b100: ALUControl = XOR ;
                        3'b101: ALUControl = SR ;
                        3'b110: ALUControl = OR ;
                        3'b111: ALUControl = AND ; 
                   endcase
            2'b11: case (funct3)
                        3'b000: ALUControl = ADD ;
                        3'b001: ALUControl = SLL ;
                        3'b010: ALUControl = SLT ;
                        3'b011: ALUControl = SLT ;
                        3'b100: ALUControl = XOR ;
                        3'b101: ALUControl = SR ;
                        3'b110: ALUControl = OR ;
                        3'b111: ALUControl = AND ; 
                   endcase
            default : ALUControl = 3'bxxx;
        endcase
    end
    
endmodule