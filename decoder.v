`include "register_file.v"

`define SIZE_DECODE_REG 64

`define DATA_SIZE_8 2'b00
`define DATA_SIZE_16 2'b01
`define DATA_SIZE_32 2'b10

`define DIR_L2R 2'b00
`define DIR_R2L 2'b01
`define DIR_NOP 2'b10

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
    reg[2:0] count_bytes_in_prefix;
    reg[2:0] data_size;
    reg[2:0] direction;
    reg[3:0] minRequiredBytes;
    reg isImmediate;
    reg hasStartAddress;
    reg[31:0] last_address;
    reg process_modrm;

    initial begin
        decode_reg = `SIZE_DECODE_REG'b0;
        decode_tmp_reg = `SIZE_DECODE_REG'b0;
        decode_hold_reg = `SIZE_DECODE_REG'b0;
        count_bytes_in_hold_reg = 4'h0;
        count_bytes_in_decode_reg = 4'h0;
        count_bytes_instr = 4'h0;
        count_bytes_in_prefix = 3'b0;
        data_size = `DATA_SIZE_32;
        direction = `DIR_L2R;
        isImmediate = 1'b0;
        hasStartAddress = 1'b0;
    end

    always @(i_reset or i_data) begin
        
        if (i_reset) begin
            decode_reg = `SIZE_DECODE_REG'b0;
            decode_tmp_reg = `SIZE_DECODE_REG'b0;
            decode_hold_reg = `SIZE_DECODE_REG'b0;
            count_bytes_in_hold_reg = 4'h0;
            count_bytes_in_decode_reg = 4'h0;
            count_bytes_instr = 4'h0;
            count_bytes_in_prefix = 3'b0;
            data_size = `DATA_SIZE_32;
            direction = `DIR_R2L;
            isImmediate = 1'b0;
            hasStartAddress = 1'b0;
        end

        if (!i_reset && i_ready && !hasStartAddress) begin
            hasStartAddress <= 1'b1;
            last_address <= i_data;
            $display("Got address");
        end

        if (!i_reset && i_ready && hasStartAddress) begin
            decode_tmp_reg = i_data;
            decode_reg = (decode_hold_reg | (decode_tmp_reg<<(8*count_bytes_in_hold_reg)));
            decode_hold_reg = decode_reg; // keep a copy here.
            count_bytes_in_decode_reg = count_bytes_in_hold_reg + 4; // Every time we get a 32 bit input from memory
            count_bytes_in_hold_reg = count_bytes_in_decode_reg;
            count_bytes_instr = 4'h0;
            count_bytes_in_prefix = 3'b0;
            process_modrm = 1'b1;
            
            /******* Start of Prefix Decoding ********/
            if (decode_reg[7:0] == 8'hf0) begin // LOCK
                count_bytes_in_prefix = 1;
            end
            
            decode_reg = (decode_hold_reg >> (8*count_bytes_in_prefix));

            if ((decode_reg[7:0] == 8'hf3) || (decode_reg[7:0] == 8'hf2)) begin // String prefixes
                count_bytes_in_prefix = count_bytes_in_prefix + 1;
            end

            decode_reg = (decode_hold_reg >> (8*count_bytes_in_prefix));

            case(decode_reg[7:0]) //Segment override TODO: Not handling segment override for now
                8'h2e: count_bytes_in_prefix = count_bytes_in_prefix + 1; // CS
                8'h36: count_bytes_in_prefix = count_bytes_in_prefix + 1; // SS
                8'h3e: count_bytes_in_prefix = count_bytes_in_prefix + 1; // DS
                8'h26: count_bytes_in_prefix = count_bytes_in_prefix + 1; // ES
                8'h64: count_bytes_in_prefix = count_bytes_in_prefix + 1; // FS
                8'h65: count_bytes_in_prefix = count_bytes_in_prefix + 1; // GS
            endcase

            decode_reg = (decode_hold_reg >> (8*count_bytes_in_prefix));

            if (decode_reg[7:0] == 8'h66) begin // Operand Override
                count_bytes_in_prefix = count_bytes_in_prefix + 1;
                data_size = `DATA_SIZE_16;
            end

            decode_reg = (decode_hold_reg >> (8*count_bytes_in_prefix));

            if (decode_reg[7:0] == 8'h67) begin // Address Override TODO: Not supporting this
                count_bytes_in_prefix = count_bytes_in_prefix + 1;
            end

            decode_reg = (decode_hold_reg >> (8*count_bytes_in_prefix));
            /******* End of Prefix Decoding ********/

            count_bytes_instr = count_bytes_in_prefix;
            
            if (count_bytes_instr < count_bytes_in_decode_reg) begin // We start the decoding only if we have enough bytes in decode reg
                if (decode_reg[7:0] == 8'h0f) begin // 2 Byte opcode
                    count_bytes_instr = count_bytes_instr + 1;
                    decode_reg = (decode_hold_reg >> (8*count_bytes_instr));

                    //TODO: Decode 2 byte opcode..not doing this for now
                end
                else begin // 1 byte opcode
                    if ((decode_reg[7:0] == 8'h00) || 
                        (decode_reg[7:0] == 8'h01) || 
                        (decode_reg[7:0] == 8'h02) ||
                        (decode_reg[7:0] == 8'h03) ||
                        (decode_reg[7:0] == 8'h04) ||
                        (decode_reg[7:0] == 8'h05) ||
                        (decode_reg[7:0] == 8'h80) ||
                        (decode_reg[7:0] == 8'h81) ||
                        (decode_reg[7:0] == 8'h83)) begin
                            
                        mnemonic = "add";
                        count_bytes_instr = count_bytes_instr + 1;
                        if (decode_reg[0] == 0) begin // 8 bit operands
                            data_size = `DATA_SIZE_8;
                        end

                        if (decode_reg[1] == 1) begin // Destination operand is register
                            direction = `DIR_R2L;
                        end

                        if (decode_reg[7] == 1) begin // Immediate operand
                            isImmediate = 1'b1;
                        end
                    end
                    
                    if (process_modrm) begin
                        if (count_bytes_instr < count_bytes_in_decode_reg) begin // This means it has the mod/rm byte
                            minRequiredBytes = (count_bytes_instr + 1 + instruction_length(decode_reg[15:8], data_size, direction, isImmediate));
                            
                            if (minRequiredBytes <= count_bytes_in_decode_reg) begin
                                $display("%x:\t%s\t %s %s", last_address, get_code(decode_reg, minRequiredBytes), mnemonic, decode_mod_reg_rm(decode_reg, data_size, direction, isImmediate));
                                decode_reg = (decode_hold_reg >> (8*minRequiredBytes));
                                decode_hold_reg = decode_reg;
                                count_bytes_in_decode_reg = count_bytes_in_hold_reg - minRequiredBytes; // No need to do this only need to update the hold reg count val
                                count_bytes_in_hold_reg = count_bytes_in_decode_reg;
                                last_address = last_address + minRequiredBytes;
                            end
                        end
                    end
                    else begin
                    end
                end
            end
        end
        else begin
            instr_size <= 1'bx;
        end
    end
   
    function string get_code(input[`SIZE_DECODE_REG-1:0] data, reg[3:0] num_bytes);
        string result = "";
        string tmpStr = "";
        reg[3:0] byte_index;
        reg[`SIZE_DECODE_REG-1:0] tmp;

        result = "";
        for (byte_index = 0; byte_index < num_bytes; byte_index = byte_index + 1) begin
            tmp = data >> (byte_index * 8);
            tmpStr = result;
            $sformat(result, "%s %x", tmpStr, tmp[7:0]);
        end

        return result;
    endfunction

    //TODO: Not supporting immediate data mode for 00, 01 and 10 cases 
    function string decode_mod_reg_rm(input[63:0] data, reg[1:0] data_size, reg[1:0] direction, reg isImmediate); // Assuming instr length 1 byte and 1 byte for mod-rm and max 4 byte displacement
        string result = "";
        string srcImmediate = "";
        case(data[15:14]) // Mod bits
            2'b00: begin // Indirect addressing mode
                if (data[10:8] == 3'b100) begin // SIB Addressing mode
                    if (data[23:22] > 0) // scaling present, TODO - verify 32 but displacement
                        $sformat(result, "%s, (%s, %s*%d+%x)", get_reg(data[13:11], data_size), get_reg(data[18:16], data_size), get_reg(data[21:19], data_size), get_scale(data[23:22]), data[55:24]);
                    else
                        $sformat(result, "%s, (%s, %s+%x)", get_reg(data[13:11], data_size), get_reg(data[18:16], data_size), get_reg(data[21:19], data_size), data[55:24]);
                end
                else if (data[10:8] == 3'b101) begin // Displacement mode
                    $sformat(result, "%x", data[47:16]);
                end
                else begin
                    result = {"(", get_reg(data[10:8], data_size), ")", ", ", get_reg(data[13:11], data_size)};
                end
            end

            2'b01: begin // Same as above but with 8 bit displacement
                if (data[10:8] == 3'b100) begin // SIB Addressing mode
                    if (data[23:22] > 0) // scaling present
                        $sformat(result, "%s, (%s,%s*%d+%x)", get_reg(data[13:11], data_size), get_reg(data[18:16], data_size), get_reg(data[21:19], data_size), get_scale(data[23:22]), data[31:24]);
                    else
                        $sformat(result, "%s, (%s, %s+%x)", get_reg(data[13:11], data_size), get_reg(data[18:16], data_size), get_reg(data[21:19], data_size), data[31:24]);
                end
                else if (data[10:8] == 3'b101) begin // Displacement mode
                    $sformat(result, "%x", data[23:16]);
                end
                else begin
                    result = {"(", get_reg(data[10:8], data_size), ")", ", ", get_reg(data[13:11], data_size)};
                end
            end

            2'b10: begin // 32-bit Displacement will be added to reg directly, TODO - Verify 32 bit displacement
                $sformat(result, "(%s+%x)", get_reg(data[10:8], data_size), data[47:16]);
            end

            2'b11: begin // Direct addressing
                if (isImmediate == 1'b0) begin
                    result = {get_reg(data[13:11], data_size), ", ", get_reg(data[10:8], data_size)};
                end
                else begin
                    if (data_size == `DATA_SIZE_8 || direction == 1'b1) begin
                        $sformat(srcImmediate, "$0x%x", data[23:16]); // 8 bit immediate data
                    end
                    else if (data_size == `DATA_SIZE_16)
                        $sformat(srcImmediate, "$0x%x", data[31:16]); // 16 bit immediate data
                    else 
                        $sformat(srcImmediate, "$0x%x", data[47:16]); // 32 bit immediate data

                    result = {srcImmediate, ",", get_reg(data[10:8], data_size)};
                end
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

    function [3:0] instruction_length(input[7:0] modrm, reg[1:0] data_size, reg[1:0] direction, reg isImmediate); // nstruction length apart from prefix,  opcode and mod/rm length
        reg[3:0] count_sib = 0;
        reg[3:0] count_displacement = 0;
        reg[3:0] count_immediate = 0;

        count_sib = 0;
        count_displacement = 0;
        count_immediate = 0;
        
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
                if (isImmediate == 1'b1) begin
                    if (data_size == `DATA_SIZE_8 || direction == 1'b1) begin
                        count_immediate = 1;
                    end
                    else if (data_size == `DATA_SIZE_16)
                        count_immediate = 2;
                    else 
                        count_immediate = 4;
                end
            end
        endcase

        instruction_length = count_sib + count_displacement + count_immediate;
    endfunction

    function string get_reg(input[2:0] code, input[1:0] data_size = `DATA_SIZE_32);
        case (code)
            3'b000: begin
                if (data_size == `DATA_SIZE_8)
                    get_reg = "%al";
                else if (data_size == `DATA_SIZE_16)
                    get_reg = "%ax";
                else
                get_reg = "%eax";
            end

            3'b001: begin
                if (data_size == `DATA_SIZE_8)
                    get_reg = "%cl";
                else if (data_size == `DATA_SIZE_16)
                    get_reg = "%cx";
                else
                get_reg = "%ecx";
            end

            3'b010: begin
                if (data_size == `DATA_SIZE_8)
                    get_reg = "%dl";
                else if (data_size == `DATA_SIZE_16)
                    get_reg = "%dx";
                else
                get_reg = "%edx";
            end

            3'b011: begin
                if (data_size == `DATA_SIZE_8)
                    get_reg = "%bl";
                else if (data_size == `DATA_SIZE_16)
                    get_reg = "%bx";
                else
                get_reg = "%ebx";
            end

            3'b100: begin
                if (data_size == `DATA_SIZE_8)
                    get_reg = "%ah";
                else if (data_size == `DATA_SIZE_16)
                    get_reg = "%sp";
                else
                get_reg = "%esp";
            end

            3'b101: begin
                if (data_size == `DATA_SIZE_8)
                    get_reg = "%ch";
                else if (data_size == `DATA_SIZE_16)
                    get_reg = "%bp";
                else
                get_reg = "%ebp";
            end

            3'b110: begin
                if (data_size == `DATA_SIZE_8)
                    get_reg = "%dh";
                else if (data_size == `DATA_SIZE_16)
                    get_reg = "%si";
                else
                get_reg = "%esi";
            end

            3'b111: begin
                if (data_size == `DATA_SIZE_8)
                    get_reg = "%bh";
                else if (data_size == `DATA_SIZE_16)
                    get_reg = "%di";
                else
                get_reg = "%edi";
            end
        endcase
    endfunction
endmodule
