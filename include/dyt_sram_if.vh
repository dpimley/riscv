/*
Description: Interfaced connections between the core and the Xilinx SRAM Module

Author: David Pimley
*/

`ifndef CPU_SRAM_IF_VH
`define CPU_SRAM_IF_VH

// Include the Common Types Package
`include "common_types.vh"

// Import the Types
import common_types::*;

interface dyt_sram_if;

    // Signals Inherent to the SRAM & CPU
    word_t              sram_address;
    word_t              sram_w_data;
    word_t              sram_r_data;
    logic               sram_ren;
    logic               sram_wen;
    
    // Declare the Modports
    
    // CPU -> SRAM
    modport cpu (
        input sram_r_data,
        output sram_address, sram_w_data, sram_ren, sram_wen
    );
    
    // SRAM -> CPU
    modport sram (
        input sram_address, sram_w_data, sram_ren, sram_wen,
        output sram_r_data
    );
    
endinterface

`endif /* CPU_SRAM_IF_VH */