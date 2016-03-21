`include "register_file.v"

`define SIZE_DECODE_REG 64

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
    reg[`SIZE_DECODE_REG-1:0] decode_reg;
    reg[`SIZE_DECODE_REG-1:0] decode_tmp_reg;
    reg[`SIZE_DECODE_REG-1:0] decode_hold_reg;
    reg[3:0] count_bytes_in_hold_reg;
    reg[3:0] count_bytes_in_decode_reg;
    reg[3:0] count_bytes_instr;

    initial begin
        decode_reg = `SIZE_DECODE_REG'b0;
        decode_tmp_reg = `SIZE_DECODE_REG'b0;
        decode_hold_reg = `SIZE_DECODE_REG'b0;
        count_bytes_in_hold_reg = 4'h0;
        count_bytes_in_decode_reg = 4'h0;
        count_bytes_instr = 4'h0;
    end

    always @(i_reset or i_data) begin
        
        if (i_reset) begin
            decode_reg = `SIZE_DECODE_REG'b0;
            decode_tmp_reg = `SIZE_DECODE_REG'b0;
            decode_hold_reg = `SIZE_DECODE_REG'b0;
            count_bytes_in_hold_reg = 4'h0;
        end

        if (!i_reset && i_ready) begin
            decode_tmp_reg = i_data;
            decode_reg = (decode_hold_reg | (decode_tmp_reg<<(8*count_bytes_in_hold_reg)));
            count_bytes_in_decode_reg = count_bytes_in_hold_reg + 4; // Every time we get a 32 bit input from memory
            
            if (decode_reg[7:0] != 8'h0f) begin // 1 Byte opcode
                opcode = i_data[7:0];
                count_bytes_instr = count_bytes_instr + 1; // Increase by 1 for one byte opcode

                case(decode_reg[7:4])
                   4'h0: begin 
                        if ((decode_reg[3:0] == 4'h0) || 
                            (decode_reg[3:0] == 4'h1) || 
                            (decode_reg[3:0] == 4'h2) ||
                            (decode_reg[3:0] == 4'h3) ||
                            (decode_reg[3:0] == 4'h4) ||
                            (decode_reg[3:0] == 4'h5)) begin
                            
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
                        if (decode_reg[3:0] == 4'h0 ||
                            decode_reg[3:0] == 4'h1 || 
                            decode_reg[3:0] == 4'h3) begin
                        
                            mnemonic = "add";
                        
                        end
                        else if (decode_reg[3:0] == 4'hB) begin
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

    function string decode_mod_reg_rm(input[63:0] data); // Assuming instr length 1 byte and 1 byte for mod-rm and max 4 byte displacement
        string result = "";
        case(data[15:14]) // Mod bits
            2'b00: begin // Indirect addressing mode
                if (data[10:8] == 3'b100) begin // SIB Addressing mode
                    if (data[23:22] > 0) // scaling present, TODO - verify 32 but displacement
                        $sformat(result, "%s, (%s, %s*%d+%x)", get_reg(data[13:11]), get_reg(data[18:16]), get_reg(data[21:19]), get_scale(data[23:22]), data[55:24]);
                    else
                        $sformat(result, "%s, (%s, %s+%x)", get_reg(data[13:11]), get_reg(data[18:16]), get_reg(data[21:19]), data[55:24]);
                end
                else if (data[10:8] == 3'b101) begin // Displacement mode
                    $sformat(result, "%x", data[47:16]);
                end
                else begin
                    result = {"(", get_reg(data[10:8]), ")", ", ", get_reg(data[13:11])};
                end
            end

            2'b01: begin // Same as above but with 8 bit displacement
                if (data[10:8] == 3'b100) begin // SIB Addressing mode
                    if (data[23:22] > 0) // scaling present
                        $sformat(result, "%s, (%s,%s*%d+%x)", get_reg(data[13:11]), get_reg(data[18:16]), get_reg(data[21:19]), get_scale(data[23:22]), data[31:24]);
                    else
                        $sformat(result, "%s, (%s, %s+%x)", get_reg(data[13:11]), get_reg(data[18:16]), get_reg(data[21:19]), data[31:24]);
                end
                else if (data[10:8] == 3'b101) begin // Displacement mode
                    $sformat(result, "%x", data[23:16]);
                end
                else begin
                    result = {"(", get_reg(data[10:8]), ")", ", ", get_reg(data[13:11])};
                end
            end

            2'b10: begin // 32-bit Displacement will be added to reg directly, TODO - Verify 32 bit displacement
                $sformat(result, "(%s+%x)", get_reg(data[10:8]), data[47:16]);
            end

            2'b11: begin // Direct addressing
                result = {get_reg(data[13:11]), ", ", get_reg(data[10:8])};
            end
        endcase

        return result;
    endfunction

    function [3:0] get_scale(input[1:0] scale_bits); // Scale value corresponding to scale bits
        case(scale_bits)
            2'b00: get_scale = 4'h1;
            2'b01: get_scale = 4'h2;
            2'b10: get_scale = 4'h4;
            2'b11: get_scale = 4'h8;
        endcase
    endfunction

    function [31:0] instruction_length(input[7:0] modrm); // Find instruction length other than opcode length and modrm byte (returns number of bytes)
        reg[31:0] count_sib = 0;
        reg[31:0] count_displacement = 0;
        case(modrm[7:6]) // mod bits
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
