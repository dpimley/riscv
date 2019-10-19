/*  Description: Register file for RISC-V. 32 bits wide, register 0 is set to 0 
 
    Base ISA -> 32 registers (x0 - x31) 
        -x0 holds the constant 0
        -user visible program counter register, holds address of current instruction
        -standard sofware calling convention, should use x1 to store return address on a call

    There is an ISA E for embedded applications that defines only 16 registerss
    
    Flip flop based. The ETH zero risc-y used differentiated between a latch based and ff based. 
    supposedly ff better for fpga so using that
    
    Author: Tommy Krause
    Date: 19 October 2019
*/

module dyt_register_file()




endmodule
