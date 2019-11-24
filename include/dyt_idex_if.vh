/*
Description: Interfaced connections between the instruction decode and instruction execute
		     stages of the pipeline. The will be the second of the two pipeline latches
  			 present in the system due to the nature our three stage pipeline. This will contain
 			 the majority of the signals coming from the decode unit. We also felt this was a semi-
			 ideal place to break up our pipeline because of the large mux-like structure that would
			 be created from the decode unit selecting the correct signals to output.

Author: David Pimley
*/

`ifndef IDEX_IF_VH
`define IDEX_IF_VH

// Include the Common Types Package
`include "common_types.vh"

// Import the Types
import common_types::*;

interface dyt_idex_if;

	// Declare Signals Inherent to the Communication between Pipeline Stages
	word_t idex_instruction_i, idex_instruction_o;
	word_t idex_pc_i, idex_pc_o;
	alu_op_t idex_alu_op_i, idex_alu_op_o;
	
	logic idex_halt_i, idex_halt_o;
	logic idex_bne_i, idex_bne_o;
	logic idex_RegWrite_i, idex_RegWrite_o;
	logic idex_RegDest_i, idex_Regdest_o;
	logic [1:0] idex_MemToReg_i, idex_MemToReg_o;
	logic [1:0] idex_AluSrc_i, idex_AluSrc_o;
	logic idex_branch_i, idex_branch_o;
	logic idex_jump_i, idex_jump_o;
	logic idex_memRead_i, idex_memRead_o;
	logic idex_memWrite_i, idex_memWrite_o;
	logic idex_imm_i, idex_imm_o;
	logic idex_half_byte_i, idex_half_byte_o;
	logic idex_update_pc_i, idex_update_pc_o;
	logic idex_jal_i, idex_jal_o;

	modport idex (
		input idex_instruction_i, idex_pc_i, idex_alu_op_i, idex_halt_i, idex_bne_i, idex_RegWrite_i,
			  idex_RegDest_i, idex_MemToReg_i, idex_AluSrc_i, idex_branch_i, idex_jump_i, idex_memRead_i,
		      idex_memWrite_i, idex_imm_i, idex_half_byte_i, idex_update_pc_i, idex_jal_i,
		output idex_instruction_o, idex_pc_o, idex_alu_op_o, idex_halt_o, idex_bne_o, idex_RegWrite_o,
			   idex_RegDest_o, idex_MemToReg_o, idex_AluSrc_o, idex_branch_o, idex_jump_o, idex_memRead_o,
		       idex_memWrite_o, idex_imm_o, idex_half_byte_o, idex_update_pc_o, idex_jal_o
	);

endinterface

`endif /* IDEX_IF_VH */
