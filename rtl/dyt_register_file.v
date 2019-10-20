/*  Description: Register file for RISC-V. 32 bits wide, register 0 is set to 0 
 
    Base ISA -> 32 registers (x0 - x31) 
        -x0 holds the constant 0
        -user visible program counter register, holds address of current instruction
        -standard sofware calling convention, should use x1 to store return address on a call

    There is an ISA E for embedded applications that defines only 16 registerss
    
    Flip flop based. The ETH zero risc-y used differentiated between a latch based and ff based. 
    supposedly ff better for fpga so using that
    
    Did some reading. Register file needs a few things: 2 simulaneous reads, one write. 
        That boils down to the following signals: rst, clk, data (32 bits), read 1 (32 bits), read 2 (32 bits),
        write enable (1 bit), write address (4 bits), read 1 (4 bits), read 2 (4 bits)
    
    Author: Tommy Krause
    Date: 19 October 2019
*/

module dyt_register_file(
    
    //Clock and write enable    
    input wire          clk,
    input wire          w_en,
    
    //Write port
    input wire [3:0]    w_addr,
    input wire [31:0]   w_data,

    //Read Port A
    input wire  [3:0]   r_a_addr,
    output wire [31:0]  r_a_data,

    //Read Port B
    input wire  [3:0]   r_b_addr,
    output wire [31:0]  r_b_data,
);

    localparam int unsigned ADDR_WIDTH  = 4;
    localparam int unsigned NUM_WORDS   = 2**ADDR_WIDTH;

    reg [NUM_WORDS-1:0][31:0]   rf_reg;
    reg [NUM_WORDS-1:0][31:0]   rf_reg_tmp; //I guess this is a shadow register of sorts
    reg [NUM_WORDS-1:1]         w_en_dec;

    // Assign x0 to zero
    assign rf_reg[0] = '0;
    
    
    // I was confused with this block but now i got it, define individual w_en signals
    integer     i;
    always @* begin : w_en_decode
        for (i = 1; i < NUM_WORDS; i = i + 1) begin
            w_en_dec[i] = (w_addr == 5'(i)) ? w_en : 1'b0;
        end
    end

    integer     r;
    //Note bounds because x0 is zero
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            /* I don't really know what the {default:'0} but I assume
                that is means set everything to zero */
            rf_reg_tmp <= '{default:'0};
        end else begin
            for (r = 1; r < NUM_WORDS; r = r + 1) begin
                if (w_en_dec[r]) rf_reg_temp[r] <= wdata;
            end
        end
    end

    assign rf_reg[NUM_WORDS-1:1] = rf_reg_tmp[NUM_WORDS-1:1];

    assign r_a_data = rf_reg[r_a_addr];
    assign r_b_data = rf_reg[r_b_addr];

endmodule
