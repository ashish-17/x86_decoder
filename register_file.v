`ifndef REGISTER_FILE_V
`define REGISTER_FILE_V

`define EAX 5'd0
`define EBX 5'd1
`define ECX 5'd2
`define EDX 5'd3
`define ESI 5'd4
`define EDI 5'd5
`define EBP 5'd6
`define ESP 5'd7

`define CS 5'd8
`define DS 5'd9
`define SS 5'd10
`define ES 5'd11
`define FS 5'd12
`define GS 5'd13

`define REG_CTRL 5'd14
`define INSTR_PTR 5'd15

`define NUM_REGISTERS 16

module register_file(
    input i_clk,
    input i_write,
    input[4:0] i_ctrl_read1,
    output[31:0] o_read_val1,
    input[4:0] i_ctrl_read2,
    output[31:0] o_read_val2,
    input[4:0] i_ctrl_write, 
    input[31:0] i_write_val);

    reg[31:0] registers[`NUM_REGISTERS-1:0];
    reg[31:0] o_read[1:0];

    assign o_read_val1 = o_read[0];
    assign o_read_val2 = o_read[1];

    integer k;
    initial begin
        for (k = 0; k < `NUM_REGISTERS; k = k + 1) begin
            registers[k] = 0;
        end
    end

    always @(i_clk or i_ctrl_read1 or i_ctrl_read2) begin
        o_read[0] = registers[i_ctrl_read1];
        o_read[1] = registers[i_ctrl_read2];
    end

    always @(negedge i_clk) begin
        if (i_write == 1) begin
            registers[i_ctrl_write] = i_write_val;
        end
    end

endmodule
`endif
