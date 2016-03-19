`include "register_file.v"

module test;

    reg clk_reg = 1'b0;
    wire clk;
    assign clk = clk_reg;
    always #5 clk_reg <= ~clk_reg;
    
    reg write = 1'b0;
    wire[31:0] r_out[1:0];
    wire[4:0] r_ctrl[1:0];
    reg[4:0] r_ctrl_reg[1:0];

    assign r_ctrl[0] = r_ctrl_reg[0];
    assign r_ctrl[1] = r_ctrl_reg[1];

    reg[31:0] w_data;
    reg[4:0] w_ctrl;
  
    integer tests = 0;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        write = 0;
        r_ctrl_reg[0] = 0;
        r_ctrl_reg[1] = 0;

        w_data = 0;
        w_ctrl = 0;
    end


    register_file uut(clk, write, r_ctrl[0], r_out[0], r_ctrl[1], r_out[1], w_ctrl, w_data);
   
    integer test_val = 0;
    always @(posedge clk) begin
        write = 1;
        w_ctrl = w_ctrl+1;
        w_data = w_data+1;
        tests = tests + 1;
        
        r_ctrl_reg[0] = w_ctrl-1;
        r_ctrl_reg[1] = w_ctrl-1;
        $display("ctrl0 = %d out0 = %d, ctrl1 = %d out1 = %d", r_ctrl[0], r_out[0], r_ctrl[1], r_out[1]);
        if (tests+1 >= 16)
            #20 $finish;
    end

endmodule
