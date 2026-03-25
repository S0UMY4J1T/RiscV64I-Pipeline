`timescale 1ns/1ps

module tb;

reg clk;
reg reset;

wire WE;
wire [63:0] WD_DataMem, A_DataMem, RD_DataMem;
wire [63:0] PC, PCD, PCE, PCM, PCW, Result;

// Instantiate DUT
Top_Module uut (
    .clk(clk),
    .reset(reset),
    .Ext_MemWrite(1'b0),
    .Ext_WriteData(64'b0),
    .Ext_DataAdr(64'b0),
    .WE(WE),
    .WD_DataMem(WD_DataMem),
    .A_DataMem(A_DataMem),
    .RD_DataMem(RD_DataMem),
    .PC(PC),
    .PCD(PCD),
    .PCE(PCE),
    .PCM(PCM),
    .PCW(PCW),
    .Result(Result)
);



// 🔁 CLOCK
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


// 🔄 RESET
initial begin
    reset = 1;
    #20;
    reset = 0;
end


// 📊 PIPELINE DEBUG (VERY IMPORTANT)
initial begin
    $display("Time\tPCF\tPCD\tPCE\tPCM\tPCW\tResult");

    forever begin
        @(posedge clk);
        $display("%0t\t%h\t%h\t%h\t%h\t%h\t%d",
            $time,
            PC,PCD, PCE, PCM, PCW, Result
        );
    end
end


// 🔥 MEMORY WRITE TRACKER (VERY USEFUL)
always @(posedge clk) begin
    if (WE) begin
        $display("📝 MEM WRITE: Addr=%h Data=%h", A_DataMem, WD_DataMem);
    end
end


// 🧪 AUTO CHECK (FINAL CONDITION)
initial begin
    // Wait enough cycles for full program
    repeat (500) @(posedge clk);

    // You can customize this based on expected result
    $display("Final Result = %h", Result);

    $display("Simulation Finished");
    $finish;
end


endmodule