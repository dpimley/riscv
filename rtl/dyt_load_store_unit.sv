/*
Description: Arbitration and Control for SRAM

    There are a few things I feel like I should point out before doing this
    
    1. If there is a data request and an instruction request (read), then the
    data will always be served first. This prevents the pipeline from moving
    until the data request is properly processed. If the instruction were to
    be serviced first then the pipeline would move on the instruction grant
    and the data service would be skipped.
    
    2. The SRAM in use has a 2-cycle read delay, and a 1-cycle write delay
    (i.e) i.e. writes happen on the next cycle. This is why I chose a state
    machine rather than cascading registers. It is easier to keep track of
    on where the read request will be finished.
    
    3. The SRAM also processes writes first in it's mode. This shouldn't
    be an issue, however, since the only time a write occurs is when a data
    request and not an instruction request occurs.
    
    This Logic can and SHOULD be improved (eventually)

Author: David Pimley
*/

`include "common_types.vh"
`include "dyt_load_store_unit.vh"
`include "dyt_sram_if.vh"

import common_types::*;

module dyt_load_store_unit
(
    // Interfaces and Logics
    input logic         clk,
    input logic         n_rst,
    dyt_load_store_unit_if.lsu lsu_if,
    dyt_sram_if.cpu sram_if
);

    // Create States for LSU
    typedef enum bit {
        IDLE,
        INSTR_1,
        INSTR_GNT,
        DATA_1,
        DATA_GNT,
        WRITE
    } lsu_state_t;
    
    // Create Local Signals
    lsu_state_t         lsu_state;
    lsu_state_t         n_lsu_state;
    
    logic               d_vld_gnted;
    logic               n_d_vld_gnted;
    
    word_t              aligned_r_data;
    word_t              aligned_w_data;
    
    // State Register
    always_ff @ (posedge clk, negedge n_rst) begin : STATE_REGISTER
        if (!n_rst) begin
            lsu_state <= IDLE;
        end else begin
            lsu_state <= n_lsu_state;
        end
    end
    
    // State Update Logic (Next State)
    always_comb begin : STATE_UPDATE
        n_lsu_state     = lsu_state;
        casez (lsu_state)
            IDLE: begin
                // See PT. 2 In the Description for Explanation on Read Priority
                if (lsu_if.mem_wen & ~d_vld_gnted) begin
                    n_lsu_state = WRITE;
                end else if ((lsu_if.mem_i_ren & ~lsu_if.mem_d_ren) | d_vld_gnted) begin
                    n_lsu_state = INSTR_1;
                end else if ((lsu_if.mem_i_ren | lsu_if.mem_d_ren) & ~d_vld_gnted) begin
                    n_lsu_state = DATA_1;
                end
            end
            INSTR_1 : begin
                n_lsu_state = INSTR_GNT;
            end
            INSTR_GNT : begin
                n_lsu_state = IDLE;
            end
            DATA_1 : begin
                n_lsu_state = DATA_GNT;
            end
            DATA_GNT : begin
                n_lsu_state = IDLE;
            end
            WRITE : begin
                n_lsu_state = IDLE;
            end
        endcase
    end
    
    // State Output Logic (Mealy)
    always_comb begin : STATE_OUTPUT
        sram_if.sram_address    = lsu_if.mem_address;
        sram_if.sram_w_data     = aligned_w_data;
        sram_if.sram_ren        = 1'b0;
        sram_if.sram_wen        = 1'b0;
        n_d_vld_gnted           = 1'b0;
        casez (lsu_state)
            IDLE: begin
                // To Prevent an Extra Cycle for Reads, The Signals Preemptively Output Combinatorially
                if (lsu_if.mem_wen & ~d_vld_gnted) begin
                    sram_if.sram_ren        = 1'b0;
                    sram_if.sram_wen        = 1'b1;
                end else if (lsu_if.mem_i_ren | lsu_if.mem_d_ren) begin
                    sram_if.sram_ren        = 1'b1;
                    sram_if.sram_wen        = 1'b0;
                end
            end
            INSTR_1 : begin
                sram_if.sram_ren        = 1'b1;
                sram_if.sram_wen        = 1'b0;                
            end
            INSTR_GNT : begin
                lsu_if.mem_r_data       = aligned_r_data;
                lsu_if.mem_i_gnt        = 1'b1; 
            end
            DATA_1 : begin
                sram_if.sram_ren        = 1'b1;
                sram_if.sram_wen        = 1'b0;     
            end
            DATA_GNT : begin
                lsu_if.mem_r_data       = aligned_r_data;
                lsu_if.mem_d_gnt        = 1'b1; 
                n_d_vld_gnted           = 1'b1;     
            end
            WRITE : begin
                sram_if.sram_ren        = 1'b0;
                sram_if.sram_wen        = 1'b1;
                n_d_vld_gnted           = 1'b1;
            end
        endcase
    end
    
    // Registers to Determine Which Requests have been Granted
    always_ff @ (posedge clk, negedge n_rst) begin : GNT_VLD_DONE
        if (!n_rst) begin
            d_vld_gnted                 <= '0;
        end else begin
            d_vld_gnted                 <= n_d_vld_gnted;
        end
    end

    // Also Need a Bit of Combinational Logic to Pad non-aligned reads / writes (may need to come back here to support unaligned loads / stores)
    always_comb begin : ALIGNMENT
        aligned_r_data                  = '0;
        aligned_w_data                  = '0;
        casez(lsu_if.mem_w_type)
            // Word Writes (Assuming 4-byte aligned address)
            MEM_W_WORD : begin
                aligned_r_data          = sram_if.sram_r_data;
                aligned_w_data          = lsu_if.mem_w_data;
            end
            // Half Word Writes (Assuming 2-byte aligned address)
            MEM_W_HWORD : begin
                aligned_r_data          = sram_if.sram_r_data & {(HWORD_W){1'b1}};
                aligned_w_data          = {{(WORD_W-HWORD_W){lsu_if.mem_w_data[HWORD_W-1]}}, lsu_if.mem_w_data[HWORD_W-1:0]};
            end
            // Half Word Writes (Assuming 2-byte aligned address)
            MEM_W_HWORDU : begin
                aligned_r_data          = sram_if.sram_r_data & {(HWORD_W){1'b1}};
                aligned_w_data          = {{(HWORD_W-BYTE_W){1'b0}}, lsu_if.mem_w_data[HWORD_W-1:0]};
            end
            // Byte Writes (Assuming 1-byte aligned address)
            MEM_W_BYTE : begin
                aligned_r_data          = sram_if.sram_r_data & {(BYTE_W){1'b1}};
                aligned_w_data          = {{(WORD_W-BYTE_W){lsu_if.mem_w_data[BYTE_W-1]}}, lsu_if.mem_w_data[BYTE_W-1:0]};
            end
            // Byte Writes (Assuming 1-byte aligned address)
            MEM_W_BYTEU : begin
                aligned_r_data          = sram_if.sram_r_data & {(BYTE_W){1'b1}};
                aligned_w_data          = {{(WORD_W-BYTE_W){1'b0}}, lsu_if.mem_w_data[BYTE_W-1:0]};
            end
        endcase
    end
    
endmodule
