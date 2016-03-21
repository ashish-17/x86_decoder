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
                        else if (i_data[3:0] == 4'hB) begin
                            mnemonic = "mov";
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

            $display("%x \t %x \t %s - %s", i_data, opcode, mnemonic, decode_mod_reg_rm(i_data));
        end
        else begin
            instr_size <= 1'bx;
        end
    end

    function string decode_mod_reg_rm(input[31:0] data);
        string result = "";
        case(data[15:14]) // Mod bits
            2'b00: begin
                
            end

            2'b01: begin
            end

            2'b10: begin
            end

            2'b11: begin // Direct addressing
                result = {get_reg(data[13:11]), ", ", get_reg(data[10:8])};
            end
        endcase

        return result;
    endfunction

    function string get_reg(input[2:0] code);
        case (code)
            3'b000: get_reg = "%eax";
            3'b001: get_reg = "%ecx";
            3'b010: get_reg = "%edx";
            3'b011: get_reg = "%ebx";
            3'b100: get_reg = "%esp";
            3'b101: get_reg = "%ebp";
            3'b110: get_reg = "%esi";
            3'b111: get_reg = "%edi";
        endcase
    endfunction
endmodule
