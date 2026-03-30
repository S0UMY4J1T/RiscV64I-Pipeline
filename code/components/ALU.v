module ALU #(
    parameter DATA_BUS_WIDTH = 64,

    parameter ADD = 3'b000,
    parameter SUB = 3'b001,
    parameter AND = 3'b010,
    parameter OR  = 3'b011,
    parameter XOR = 3'b100,
    parameter SLT = 3'b101,
    parameter SLL = 3'b110,
    parameter SR  = 3'b111
) (
    input      [DATA_BUS_WIDTH-1 : 0] SrcA, SrcB,
    input      [2:0]                  funct3,
    input                             funct7b5, OPb4,
    input      [2:0]                  ALUControl,
    output reg                        Condition,
    output reg [DATA_BUS_WIDTH-1 : 0] ALUResult
);

    wire [31:0] A32 = SrcA[31:0];
    wire [31:0] B32 = SrcB[31:0];
    reg  [31:0] ALUResult32 ;

    always @(*) begin
        casex (funct3)
            3'b000: Condition =  (SrcA == SrcB);
            3'b001: Condition = !(SrcA == SrcB);
            3'b100: begin
                if (SrcA[DATA_BUS_WIDTH-1] == SrcB[DATA_BUS_WIDTH-1]) Condition = (SrcA < SrcB);
                else Condition = SrcA[DATA_BUS_WIDTH-1];
            end
            3'b101: begin
                if (SrcA[DATA_BUS_WIDTH-1] == SrcB[DATA_BUS_WIDTH-1]) Condition = !(SrcA < SrcB);
                else Condition = !SrcA[DATA_BUS_WIDTH-1];
            end
            3'b110: Condition =  (SrcA < SrcB) ;
            3'b111: Condition = !(SrcA < SrcB) ;
            default: Condition = 1'bx;
        endcase
    end

    always @(*) begin
        if (OPb4) begin
            case (ALUControl)
                ADD : ALUResult32 = A32 + B32  ; 
                SUB : ALUResult32 = A32 + ~B32 + 1 ;
                // AND : ALUResult32 = A32 & B32 ;
                // OR  : ALUResult32 = A32 | B32 ;
                // XOR : ALUResult32 = A32 ^ B32 ;
                SLL : ALUResult32 = A32 << B32[4:0] ;
                // SLT : begin
                //     if (funct3[0]) ALUResult32 = (A32 < B32);  //SLTU
                //     else begin                                 //SLT
                //         if (A32[31] == B32[31]) ALUResult32 = (A32 < B32);
                //         else ALUResult32 = A32[31];
                //     end 
                // end
                SR  : begin   
                    if (funct7b5) ALUResult32 =  $signed(A32) >>> B32[4:0] ;       //SRA
                    else ALUResult32 = A32 >> B32[4:0] ;                    //SRL
                end
            endcase
            ALUResult = { {32{ALUResult32[31]}} , ALUResult32[31:0] } ;
        end else begin
            case (ALUControl)
                ADD : ALUResult = SrcA + SrcB  ; 
                SUB : ALUResult = SrcA + ~SrcB + 1 ;
                AND : ALUResult = SrcA & SrcB ;
                OR  : ALUResult = SrcA | SrcB ;
                XOR : ALUResult = SrcA ^ SrcB ;
                SLL : ALUResult = SrcA << SrcB[5:0] ;
                SLT : begin
                    if (funct3[0]) ALUResult = (SrcA < SrcB);  //SLTU
                    else begin                                 //SLT
                        if (SrcA[DATA_BUS_WIDTH-1] == SrcB[DATA_BUS_WIDTH-1]) ALUResult = (SrcA < SrcB);
                        else ALUResult = SrcA[DATA_BUS_WIDTH-1];
                    end 
                end
                SR  : begin   
                    if (funct7b5) ALUResult =  $signed(SrcA) >>> SrcB[5:0] ;       //SRA
                    else ALUResult = SrcA >> SrcB[5:0] ;                    //SRL
                end
            endcase
        end
        
    end
    
endmodule