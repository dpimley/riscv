/*
Description: Interfaced connections between the ALU and the top level
             connections

Author: David Pimley
*/

`ifndef ALU_IF_VH
`define ALU_IF_VH

// Include the Common Types Package
`include "common_types.vh"

// Import the Types
import common_types::*;

interface dyt_alu_if;

    // Signals Inherent to the ALU & CPU
    logic alu_negative, alu_overflow, alu_zero;
    word_t alu_port_0, alu_port_1, alu_port_out;
    alu_op_t alu_op;
    
    // Declare the Modports
    
    // CPU -> ALU
    modport cpu (
        input alu_negative, alu_overflow, alu_zero, alu_port_out,
        output alu_port_0, alu_port_1, alu_op
    );
    
    // ALU -> CPU
    modport alu (
        input alu_port_0, alu_port_1, alu_op,
        output alu_negative, alu_overflow, alu_zero, alu_port_out
    );
    
endinterface

`endif /* ALU_IF_VH */
