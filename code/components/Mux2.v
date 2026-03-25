module Mux2 #(
    parameter DATA_BUS_WIDTH = 64
) (
    input                         sel ,
    input  [DATA_BUS_WIDTH-1 : 0] in1 , in2 ,
    output [DATA_BUS_WIDTH-1 : 0] out
);

    assign out = (sel)? in2 : in1 ; 
    
endmodule