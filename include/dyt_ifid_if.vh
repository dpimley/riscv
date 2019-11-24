/*
Description: Interfaced connections between stages of the system level execution.
			 These signals should correspond to the signals needed for communcation
			 between the instruction fetch and instruction decode stages of the 
			 pipeline.
	
			 This is the most lightweight of all the latches because it requires
			 only a few necessary signals to be propagated down the pipeline and
			 control the logic latching the relevant signals

Author: David Pimley
*/

`ifndef IFID_IF_VH
`define IFID_IF_VH

// Include the Common Types Package
import common_types::*;

interface dyt_ifid_if_vh;

	// Signals Inherent to the IFID Stage Communication
	word_t	ifid_instruction_i, ifid_instruction_o;
	word_t 	ifid_pc_i, ifid_pc_o;	

	// Delcare the Modports
	
	// IF -> ID
	modport ifid (
		input ifid_instruction_i, ifid_pc_i,
		output ifid_instruction_o, ifid_pc_o
	); 
	
endinterface

`endif /* IFID_IF_VH */
