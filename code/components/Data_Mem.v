// data_mem.v - data memory

module Data_mem #(
    parameter DATA_WIDTH = 64,
    parameter ADDR_WIDTH = 64,
    parameter MEM_SIZE   = 64
)(
    input                       clk,
    input                       WE,
    input       [2:0]           funct3,
    input       [ADDR_WIDTH-1:0] A_ByteAddressable,
    input       [DATA_WIDTH-1:0] WD,
    output reg  [DATA_WIDTH-1:0] RD
);

    reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];

    wire [$clog2(MEM_SIZE)-1:0] A_WordAddressable;
    wire [2:0]  Byte_Offset;
    reg  [7:0]  lb_bits;
    reg  [15:0] lh_bits;
    reg  [31:0] lw_bits;

    assign A_WordAddressable = A_ByteAddressable[$clog2(MEM_SIZE)+1 : 3];
    assign Byte_Offset = A_ByteAddressable[2:0] ; 

    // Read logic
    always @(*) begin
        case (Byte_Offset)       //LB, LBU
                    3'b000: lb_bits = data_ram[A_WordAddressable][ 7: 0];
                    3'b001: lb_bits = data_ram[A_WordAddressable][15: 8];
                    3'b010: lb_bits = data_ram[A_WordAddressable][23:16];
                    3'b011: lb_bits = data_ram[A_WordAddressable][31:24];
                    3'b100: lb_bits = data_ram[A_WordAddressable][39:32];
                    3'b101: lb_bits = data_ram[A_WordAddressable][47:40];
                    3'b110: lb_bits = data_ram[A_WordAddressable][55:48];
                    3'b111: lb_bits = data_ram[A_WordAddressable][63:56];
        endcase

        case (Byte_Offset)      //LH, LHU
                    3'b000: lh_bits = data_ram[A_WordAddressable][15: 0];
                    3'b001: lh_bits = data_ram[A_WordAddressable][23: 8];
                    3'b010: lh_bits = data_ram[A_WordAddressable][31:16];
                    3'b011: lh_bits = data_ram[A_WordAddressable][39:24];
                    3'b100: lh_bits = data_ram[A_WordAddressable][47:32];
                    3'b101: lh_bits = data_ram[A_WordAddressable][55:40];
                    3'b110: lh_bits = data_ram[A_WordAddressable][63:48];
        endcase

        case (Byte_Offset)      //LW, LWU
                    3'b000: lw_bits = data_ram[A_WordAddressable][31: 0];
                    3'b001: lw_bits = data_ram[A_WordAddressable][39: 8];
                    3'b010: lw_bits = data_ram[A_WordAddressable][47:16];
                    3'b011: lw_bits = data_ram[A_WordAddressable][55:24];
                    3'b100: lw_bits = data_ram[A_WordAddressable][63:32];
                    3'b101: lw_bits = { data_ram[A_WordAddressable + 1][ 7: 0] , data_ram[A_WordAddressable][63:40]};
                    3'b110: lw_bits = { data_ram[A_WordAddressable + 1][15: 8] , data_ram[A_WordAddressable][63:48]};
                    3'b111: lw_bits = { data_ram[A_WordAddressable + 1][23:16] , data_ram[A_WordAddressable][63:56]};
        endcase

        case (funct3)
            3'b000: RD = {{56{lb_bits[ 7]}}, lb_bits};  // lb
            3'b001: RD = {{48{lh_bits[15]}}, lh_bits};  // lh
            3'b010: RD = {{32{lw_bits[31]}}, lw_bits};  // lw
            3'b011: RD = data_ram[A_WordAddressable];   // ld
            3'b100: RD = {56'b0, lb_bits};              // lbu
            3'b101: RD = {48'b0, lh_bits};              // lhu
            3'b110: RD = {32'b0, lw_bits};              // lwu
        endcase
    end

    // Write logic
    always @(posedge clk ) begin
        if (WE) begin
            case (funct3)
                3'b000: begin      //SB
                    case (Byte_Offset)
                        3'b000: data_ram[A_WordAddressable][ 7: 0] <= WD[7:0];
                        3'b001: data_ram[A_WordAddressable][15: 8] <= WD[7:0];
                        3'b010: data_ram[A_WordAddressable][23:16] <= WD[7:0];
                        3'b011: data_ram[A_WordAddressable][31:24] <= WD[7:0];
                        3'b100: data_ram[A_WordAddressable][39:32] <= WD[7:0];
                        3'b101: data_ram[A_WordAddressable][47:40] <= WD[7:0];
                        3'b110: data_ram[A_WordAddressable][55:48] <= WD[7:0];
                        3'b111: data_ram[A_WordAddressable][63:56] <= WD[7:0];
                    endcase
                end

                3'b001: begin     //SH
                    case (Byte_Offset)
                        3'b000: data_ram[A_WordAddressable][15: 0] <= WD[15:0];
                        3'b001: data_ram[A_WordAddressable][23: 8] <= WD[15:0];
                        3'b010: data_ram[A_WordAddressable][31:16] <= WD[15:0];
                        3'b011: data_ram[A_WordAddressable][39:24] <= WD[15:0];
                        3'b100: data_ram[A_WordAddressable][47:32] <= WD[15:0];
                        3'b101: data_ram[A_WordAddressable][55:40] <= WD[15:0];
                        3'b110: data_ram[A_WordAddressable][63:48] <= WD[15:0];
                    endcase
                      
                end

                3'b010: begin     //SW
                    case (Byte_Offset)
                        3'b000: data_ram[A_WordAddressable][31: 0] <= WD[31:0];
                        3'b001: data_ram[A_WordAddressable][39: 8] <= WD[31:0];
                        3'b010: data_ram[A_WordAddressable][47:16] <= WD[31:0];
                        3'b011: data_ram[A_WordAddressable][55:24] <= WD[31:0];
                        3'b100: data_ram[A_WordAddressable][63:32] <= WD[31:0];
                    endcase
                end

                3'b011: data_ram[A_WordAddressable] <= WD ;    //SD
            endcase
        end 
    end

endmodule


