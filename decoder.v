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
            2'b00: begin // Indirect addressing mode
                if (data[10:8] == 3'b100) begin // SIB Addressing mode
                    if (data[23:22] > 0) // scaling present, TODO - instead of 8 bit displacement use 32 bit
                        $sformat(result, "%s, (%s, %s*%d+%x)", get_reg(data[13:11]), get_reg(data[18:16]), get_reg(data[21:19]), data[23:22], data[31:24]);
                    else
                        $sformat(result, "%s, (%s, %s+%x)", get_reg(data[13:11]), get_reg(data[18:16]), get_reg(data[21:19]), data[31:24]);
                end
                else if (data[10:8] == 3'b101) begin // Displacement mode
                    result = "read 4 byte displacement..not implemented";
                end
                else begin
                    result = {"(", get_reg(data[10:8]), ")", ", ", get_reg(data[13:11])};
                end
            end

            2'b01: begin // Same as above but with 8 bit displacement
                if (data[10:8] == 3'b100) begin // SIB Addressing mode
                    if (data[23:22] > 0) // scaling present
                        $sformat(result, "%s, (%s,%s*%d+%x)", get_reg(data[13:11]), get_reg(data[18:16]), get_reg(data[21:19]), data[23:22], data[31:24]);
                    else
                        $sformat(result, "%s, (%s, %s+%x)", get_reg(data[13:11]), get_reg(data[18:16]), get_reg(data[21:19]), data[31:24]);
                end
                else if (data[10:8] == 3'b101) begin // Displacement mode
                    result = "read 4 byte displacement..not implemented";
                end
                else begin
                    result = {"(", get_reg(data[10:8]), ")", ", ", get_reg(data[13:11])};
                end
            end

            2'b10: begin // 32-bit Displacement will be added to reg directly, TODO - For now 32 bit displacement is not supported
                $sformat(result, "(%s+???)", get_reg(data[10:8]));
            end

            2'b11: begin // Direct addressing
                result = {get_reg(data[13:11]), ", ", get_reg(data[10:8])};
            end
        endcase

        return result;
    endfunction

    function [31:0] instruction_length(input[7:0] modrm); // Find instruction length other than opcode length and modrm byte (returns number of bytes)
        reg[31:0] count_sib = 0;
        reg[31:0] count_displacement = 0;
        case(modrm[8:7]) // mod bits
            2'b00: begin
                if (modrm[2:0] == 3'b100) begin
                    count_sib = 31'd1;
                    count_displacement = 31'd4;
                end
                else if (modrm[2:0] == 3'b101) begin
                    count_displacement = 31'd4;
                end
            end

            2'b01: begin
                if (modrm[2:0] == 3'b100) begin
                    count_sib = 31'd1;
                    count_displacement = 31'd1;
                end
                else if (modrm[2:0] == 3'b101) begin
                    count_displacement = 31'd1;
                end
            end

            2'b10: begin
                count_displacement = 31'd4;
            end

            2'b11: begin
            end
        endcase

        instruction_length = count_sib + count_displacement;
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
