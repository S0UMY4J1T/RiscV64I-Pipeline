module Mux4 #(
    parameter DATA_BUS_WIDTH = 64
) (
    input  [1:0]                  sel,
    input  [DATA_BUS_WIDTH-1 : 0] in1, in2, in3, in4,
    output [DATA_BUS_WIDTH-1 : 0] out
);

    assign out = (sel[1])? (sel[0])? in4 : in3  : (sel[0])? in2 : in1  ; 
    
endmodule