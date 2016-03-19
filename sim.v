`ifndef SIM_V
`define SIM_V
// Simulation module
module sim#(parameter MAX_CYCLES=10000)(
  output clk,
  output reset
);

  reg reset_reg = 1'b1;
  assign reset = reset_reg;

  // VCD Dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #10 reset_reg <= 1'b0;
    #1000 $finish;
  end

  reg clk_reg = 1'b0;
  assign clk = clk_reg;

  // 10 time units per cycle
  always #5 clk_reg <= ~clk_reg;

endmodule
`endif
