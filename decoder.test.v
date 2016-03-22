`include "memory.v"
`include "register_file.v"
`include "sim.v"
`include "decoder.v"

`define ADDRESS_WIDTH 32
`define DATA_WIDTH 32

module decoder_test();

wire reset;
wire clk;

reg [`ADDRESS_WIDTH-1:0] mem_address = 0;
wire [`DATA_WIDTH-1:0]   mem_data_out;
reg[31:0] decoder_inp;
reg[1:0] instr_size;

reg mem_cmd = `MEM_CMD_READ;

reg mem_valid;
wire mem_ready;
wire mem_res_valid;

integer tests;
initial begin
    //$dumpfile("dump.vcd");
   // $dumpvars;
    tests = 0;
end

always @(posedge clk) begin
  if (!reset && mem_ready) begin
    mem_valid <= 1;
    decoder_inp = mem_data_out;
  end

  if (!reset && mem_res_valid) begin
    mem_valid <= 0;
   // $display("Address = %h, data = %h, data 2 = %h", mem_address, mem_data_out, decoder_inp);

    mem_address += (`DATA_WIDTH / 8);
    //tests += 1;

    //if (tests > 20)
      //  #20 $finish;
  end
end

decoder my_decoder(
    .i_clk(clk), 
    .i_reset(reset), 
    .i_ready(mem_valid), 
    .i_data(decoder_inp), 
    .o_instr_size(instr_size));

// Memory module
memory #(`ADDRESS_WIDTH, `DATA_WIDTH) my_mem(
  .clk(clk),
  .reset(reset),

  .i_address(mem_address),
  .i_res_ready(1'b1), //we are always ready to receive data
  .i_cmd(mem_cmd), //R/W
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
