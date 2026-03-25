module Adder #(
    parameter DATA_BUS_WIDTH = 64 
) ( 
    input  [DATA_BUS_WIDTH-1 : 0] in1, in2,
    output [DATA_BUS_WIDTH-1 : 0] out
);

    assign out = in1 + in2 ;
    
endmodule