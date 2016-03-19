`include "memory.v"
`include "sim.v"

`define ADDRESS_WIDTH 32
`define DATA_WIDTH 32

module test();

wire reset;
wire clk;

reg [`ADDRESS_WIDTH-1:0] mem_address = 0;
wire [`DATA_WIDTH-1:0]   mem_data_out;

reg mem_valid;
wire mem_ready;
wire mem_res_valid;

always @(posedge clk) begin
  if (!reset && mem_ready) begin
    mem_valid <= 1;
  end

  if (!reset && mem_res_valid) begin
    mem_valid <= 0;
    mem_address += (`DATA_WIDTH / 8);
  end
end

// ALU module
memory #(`ADDRESS_WIDTH, `DATA_WIDTH) my_mem(
  .clk(clk),
  .reset(reset),

  .i_address(mem_address),
  .i_res_ready(1'b1), //we are always ready to receive data
  .i_cmd(`MEM_CMD_READ), //RO
  .i_data(`DATA_WIDTH'bx),//no write data
  .i_valid(mem_valid),

  .o_data(mem_data_out),
  .o_res_valid(mem_res_valid),
  .o_ready(mem_ready)
);

// Simulator (clock + reset)
sim my_sim(
  .clk(clk),
  .reset(reset)
);

endmodule
