`include "register_file.v"

module decoder(
    input i_clk,
    input i_reset,
    input i_ready,
    input[31:0] i_data, 
    output[1:0] o_instr_size);

    string mnemonic;
    reg[31:0] opcode;
    reg[1:0] instr_size;
    assign o_instr_size = instr_size;

    initial begin
    end

    always @(posedge i_clk) begin

        if (!i_reset && i_ready) begin
            if (i_data[7:0] != 8'h0f) begin // 1 Byte opcode
                opcode = i_data[7:0];

                case(i_data[7:4])
                   4'h0: begin 
                        if ((i_data[3:0] == 4'h0) || 
                            (i_data[3:0] == 4'h1) || 
                            (i_data[3:0] == 4'h2) ||
                            (i_data[3:0] == 4'h3) ||
                            (i_data[3:0] == 4'h4) ||
                            (i_data[3:0] == 4'h5)) begin
                            
                            mnemonic = "add";
                        
                        end
                    end

                    4'h1: begin 
                    end
                    
                    4'h2: begin 
                    end

                    4'h3: begin 
                    end
                    
                    4'h4: begin 
                    end
                    
                    4'h5: begin 
                    end
                    
                    4'h6: begin 
                    end
                    
                    4'h7: begin 
                    end
                    
                    4'h8: begin 
                        if (i_data[3:0] == 4'h0 ||
                            i_data[3:0] == 4'h1 || 
                            i_data[3:0] == 4'h3) begin
                        
                            mnemonic = "add";
                        
                        end
                    end
                    
                    4'h9: begin 
                    end
                    
                    4'hA: begin 
                    end
                    
                    4'hB: begin 
                    end
                    
                    4'hC: begin 
                    end
                    
                    4'hD: begin 
                    end
                    
                    4'hE: begin 
                    end
                    
                    4'hF: begin 
                    end
                endcase
            end
            else begin
                // Not implemented
            end

            $display("%x \t %x \t %s", i_data, opcode, mnemonic);
        end
        else begin
            instr_size <= 1'bx;
        end
    end
endmodule
