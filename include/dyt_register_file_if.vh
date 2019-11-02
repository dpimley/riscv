/*
Description: Interfaced connections between the register file and the top level
             connections

Author: David Pimley
*/

`ifndef CPU_REGISTER_FILE_IF_VH
`define CPU_REGISTER_FILE_IF_VH

// Include the Common Types Package
`include "common_types.vh"

// Import the Types
import common_types::*;

interface dyt_register_file_if;

    // Signals Inherent to the Register File & CPU
    logic               rf_wen;
    word_t              rf_w_data, rf_r_data_0, rf_r_data_1;
    rf_addr_t           rf_w_sel, rf_r_sel_0, rf_r_sel_1;
    
    // Declare the Modports
    
    // CPU -> Register File
    modport cpu (
        input rf_r_data_0, rf_r_data_1,
        output rf_wen, rf_w_data, rf_w_sel, rf_r_sel_0, rf_r_sel_1
    );
    
    // Register File -> CPU
    modport rf (
        input rf_wen, rf_w_data, rf_w_sel, rf_r_sel_0, rf_r_sel_1,
        output rf_r_data_0, rf_r_data_1
    );
    
endinterface

`endif /* CPU_REGISTER_FILE_IF_VH */