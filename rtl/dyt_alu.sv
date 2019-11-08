/*
Description: Arithmetic Logic Unit for execution of instructions

Author: David Pimley
*/

`include "common_types.vh"
`include "dyt_alu_if.vh"

import common_types::*;

module dyt_alu(
    dyt_alu_if.alu alu_if
);

    always_comb begin : DYT_ALU_SWITCH_OP
        alu_if.alu_port_out = '0;
        alu_if.alu_overflow = '0;
        case (alu_if.alu_op)
            ALU_ADD: begin
                alu_if.alu_port_out = alu_if.alu_port_0 + alu_if.alu_port_1;
                alu_if.alu_overflow = (alu_if.alu_port_0[WORD_W-1] ~^ alu_if.alu_port_1[WORD_W-1]) & 
                                      (alu_if.alu_port_0[WORD_W-1] ~^ alu_if.alu_port_out[WORD_W-1]);
            end
            ALU_ADDU: begin
                alu_if.alu_port_out = $signed(alu_if.alu_port_0) + $signed(alu_if.alu_port_1);
                alu_if.alu_overflow = (alu_if.alu_port_0[WORD_W-1] ~^ alu_if.alu_port_1[WORD_W-1]) & 
                                      (alu_if.alu_port_0[WORD_W-1] ~^ alu_if.alu_port_out[WORD_W-1]);
            end
            ALU_SUB: begin
                alu_if.alu_port_out = $signed(alu_if.alu_port_0) + $signed(alu_if.alu_port_1);
                alu_if.alu_overflow = (alu_if.alu_port_0[WORD_W-1] ~^ alu_if.alu_port_1[WORD_W-1]) & 
                                      (alu_if.alu_port_0[WORD_W-1] ^ alu_if.alu_port_out[WORD_W-1]);
            end
            ALU_SUBU: begin
                alu_if.alu_port_out = $signed(alu_if.alu_port_0) + $signed(alu_if.alu_port_1);
                alu_if.alu_overflow = (alu_if.alu_port_0[WORD_W-1] ~^ alu_if.alu_port_1[WORD_W-1]) & 
                                      (alu_if.alu_port_0[WORD_W-1] ^ alu_if.alu_port_out[WORD_W-1]);
            end
            ALU_OR: begin
                alu_if.alu_port_out = alu_if.alu_port_0 | alu_if.alu_port_1;
            end
            ALU_AND: begin
                alu_if.alu_port_out = alu_if.alu_port_0 & alu_if.alu_port_1;
            end
            ALU_XOR: begin
                alu_if.alu_port_out = alu_if.alu_port_0 ^ alu_if.alu_port_1;
            end
            ALU_SRA: begin
                alu_if.alu_port_out = alu_if.alu_port_0 >>> alu_if.alu_port_1;
            end
            ALU_SRL: begin
                alu_if.alu_port_out = alu_if.alu_port_0 >> alu_if.alu_port_1;
            end
            ALU_SLL: begin
                alu_if.alu_port_out = alu_if.alu_port_0 << alu_if.alu_port_1;
            end
            ALU_SLT: begin
                alu_if.alu_port_out = ($signed(alu_if.alu_port_0) < $signed(alu_if.alu_port_1)) ? 32'h00000001 : '0;
            end
            ALU_SLTU: begin
                alu_if.alu_port_out = (alu_if.alu_port_0 < alu_if.alu_port_1) ? 32'h00000001 : '0;
            end
        endcase
    end
    
// Determine Zero & Negative Signals
assign alu_if.alu_zero = ~(|alu_if.alu_port_out);
assign alu_if.alu_negative = alu_if.alu_port_out[WORD_W-1];

endmodule
