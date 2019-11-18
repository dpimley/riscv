/*
Description: Interfaced connections between the Decode unit and the top level
             connections

Author: Yash Bharatula
*/

`ifndef DECODE_IF_VH
`define DECODE_IF_VH

// Include the Common Types Package
`include "common_types.vh"

// Import the Types
import common_types::*;

interface dyt_decode_if;
	
	logic [WORD_W-1:0] instr;
	logic halt;
	logic bne;
    logic RegWrite;
    logic RegDest;
	logic [1:0] MemToReg;
	logic [ALU_OP_W-1:0] AluOp;
    logic [1:0] AluSrc;
    logic branch;
	logic jump;
	logic memRead, memWrite; 
	logic imm;
    logic half_byte;
    logic update_pc;
	logic jal;
    // Declare the Modports
    
    // CPU -> Decode Unit
    modport cpu (
        input instr,
        output halt, bne, RegWrite, RegDest, MemToReg, AluOp, AluSrc, branch, jump, memRead, memWrite, imm, 
		half_byte, update_pc, jal
    );
    
    // Decode Unit -> CPU
    modport tb (
        output instr,
        input halt, bne, RegWrite, RegDest, MemToReg, AluOp, AluSrc, branch, jump, memRead, memWrite, imm, 
		half_byte, update_pc, jal
    );
    
endinterface

`endif /* DECODE_IF_VH */
