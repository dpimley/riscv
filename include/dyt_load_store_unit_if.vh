/*
Description: Interfaced connections between the load store unit and the
             top level connections

Author: David Pimley
*/

`ifndef CPU_LOAD_STORE_UNIT_IF_VH
`define CPU_LOAD_STORE_UNIT_IF_VH

// Include the Common Types Package
`include "common_types.vh"
`include "dyt_sram_if.vh"

// Import the Types
import common_types::*;

interface dyt_load_store_unit_if;

    // Signals Inherent to the LSU & CPU
    word_t              mem_address;
    word_t              mem_w_data;
    word_t              mem_r_data;
    logic               mem_d_ren;
    logic               mem_i_ren;
    logic               mem_wen;
    logic               mem_d_gnt;
    logic               mem_i_gnt;
    lsu_mem_w_type_t    mem_w_type;
    
    // CPU -> LSU
    modport cpu (
        input mem_r_data, mem_d_gnt, mem_i_gnt,
        output mem_address, mem_w_data, mem_d_ren, mem_i_ren, mem_wen, mem_w_type
    );
    
    // LSU -> CPU
    modport lsu (
        input mem_address, mem_w_data, mem_d_ren, mem_i_ren, mem_wen, mem_w_type,
        output mem_r_data, mem_d_gnt, mem_i_gnt
    );
    
endinterface
`endif  /* CPU_LOAD_STORE_UNIT_IF_VH */