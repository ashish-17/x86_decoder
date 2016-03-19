`ifndef MEMORY_V
`define MEMORY_V

`define MEM_CMD_WIDTH  1
`define MEM_CMD_READ   1'b0
`define MEM_CMD_WRITE  1'b1

module memory#(
  parameter ADDRESS_WIDTH=32,
  parameter DATA_WIDTH=32,
  parameter SIZE = 1024*1024,
  parameter READ_DELAY = 22,
  parameter WRITE_DELAY = 15
)(
  input clk,
  input reset,

  input [ADDRESS_WIDTH-1:0]i_address,
  input [DATA_WIDTH-1:0]i_data,
  input i_valid,
  input i_res_ready,
  input i_cmd,

  output [DATA_WIDTH-1:0]o_data,
  output o_res_valid,
  output o_ready
);

`define CELLS (SIZE / (DATA_WIDTH / 8))
reg [DATA_WIDTH-1:0]memory_cells [0:`CELLS];

wire [ADDRESS_WIDTH-1:0]cell_address = i_address >> $clog2(DATA_WIDTH/8);
reg ready;
reg res_valid;
reg [DATA_WIDTH-1:0]data;

assign o_data = data;
assign o_res_valid = res_valid;
assign o_ready = ready;

//load data
initial begin
  string file;
  integer fd, size, result;
  if ($value$plusargs("img=%s", file)) begin
    // get file size
    fd = $fopen(file, "r");
    result = $fseek(fd, 0, 2);
    result = $ftell(fd);
    $fclose(fd);

    size = (result / 11); // '0' + 'x' + 8chars + lf,
    //one cell -- one line no matter the cell size

    $display("Loading img file: %s, file size: %d, cells: %d", file, result, size);
    $readmemh(file, memory_cells, 0, size - 1); // '0' + 'x' + 8chars + lf
    $display("The first word is: %x", memory_cells[0]);
    $display("The second word is: %x", memory_cells[1]);
  end else begin
    $display("Please specify input image file '+img'");
  end
end

// reset
always @(posedge clk) begin
  if (reset) begin
    ready = 1'b1;
    res_valid = 1'b0;
    data  = 1'bx;
  end

  if (!reset && i_valid && o_ready) begin
    case (i_cmd)
    //read takes 
    `MEM_CMD_READ: begin
      #READ_DELAY data <= memory_cells[cell_address];
      #READ_DELAY res_valid <= 1'b1;
      ready <= 1'b0;
    end
    `MEM_CMD_WRITE: begin
      //TODO
      $display("Mem Write not implemented");
      $finish();
    end
    endcase
  end

  if (!reset && res_valid && i_res_ready) begin
    ready <= 1'b1;
    res_valid <= 1'b0;
    data  <= 1'bx;
  end
end

endmodule
`endif
