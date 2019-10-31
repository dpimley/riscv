/*  Description: Basic Dual Port SRAM for RISC-V. Column & Row Decoder for each input address
 
    This SRAM fits exactly the needs to of the core. In that sense there will be at most 1 write and
    a possiblity of 1 read coming from the address of the memory.

    The SRAM itself is a 2 dimensional based memory with each access as a word

    Doing a read and write at the same time also necessitates the need for an arbiter

    Author: David Pimley
    Date: 31 October 2019
*/

`include common_types.vh

module dyt_sng_sram(
    
    // Reset and Clock
    input wire          rst,                            // active low asynchronous reset
    input wire          clk,                            // driver clock
    
    // Write Port A
    input wire [`WORD_W-1:0]    dyt_sram_w_addr_0,      // write address 0
    input wire [`WORD_W-1:0]    dyt_sram_w_data_0,      // write data 0


    // Read Port A
    input wire  [`WORD_W-1:0]   dyt_sram_r_addr_0,      // read address 0
    output wire [`WORD_W-1:0]   dyt_sram_r_data_0,      // read data 0
    output wire                 dyt_sram_r_hit_0,       // indicates value is ready

);

    // Local Parameters to Configure the SRAM
    localparam SRAM_BYTES       = 4096;                 // bytes of the sram
    localparam SRAM_WORDS       = SRAM_BYTES / `WBYTES;
                                                        // words of the sram
    localparam SRAM_ROWS        = SRAM_WORDS / 2;       // how many rows of the 2-d array
    localparam SRAM_COLS        = SRAM_WORDS / 2;       // how many cols of the 2-d array
    localparam SRAM_ROWS_BITS   = $clog2(SRAM_ROWS);    // bit representation of rows
    localparam SRAM_COLS_BITS   = $clog2(SRAM_COLS);    // bit representation of cols 
    localparam SRAM_MOD_BITS    = $clog2(SRAM_WORDS);   // bit representation of modified address

    // Instantiate Extra Variables
    integer row;
    integer col;

    // Instantiate Local Hardware
    wire [SRAM_ROWS_BITS-1:0]   dyt_sram_row;           // decoded row address
    wire [SRAM_COLS_BITS-1:0]   dyt_sram_col;           // decoded col address

    wire [SRAM_MOD_BITS-1:0]    dyt_sram_w_addr_mod;    // cheap modulus version of write address
    wire [SRAM_MOD_BITS-1:0]    dyt_sram_r_addr_mod;    // cheap modulus version of read address


    reg  [`WORD_W-1:0] dyt_sram [SRAM_ROWS-1:0][SRAM_COLS-1:0];
                                                        // the 2 dimensional memory

    // Create the "Cheap Modulus" Address
    assign dyt_sram_w_addr_mod  = dyt_sram_w_addr_0[SRAM_MOD_BITS-1:0];
    assign dyt_sram_r_addr_mod  = dyt_sram_r_addr_0[SRAM_MOD_BITS-1:0]; 

    // Instantiate the Row Decoders
    assign dyt_sram_r_row       = dyt_sram_r_addr_mod[SRAM_MOD_BITS-1:SRAM_MOD_BITS-SRAM_COLS_BITS];
    assign dyt_sram_w_row       = dyt_sram_w_addr_mod[SRAM_MOD_BITS-1:SRAM_MOD_BITS-SRAM_COLS_BITS];

    // Instantiate the Column Decoders
    assign dyt_sram_r_col       = dyt_sram_r_addr_mod[SRAM_COLS_BITS-1:0];
    assign dyt_sram_w_col       = dyt_sram_w_addr_mod[SRAM_COLS_BITS-1:0];

    // Sequential Logic for the Write of the SRAM
    always @ (posedge clk, negedge rst) begin
        if (rst == 1'b0) begin
            for (row = 0; row < SRAM_ROWS; row++) begin
                for (col = 0; col < SRAM_COLS; col++) begin
                   dyt_sram[row][col] <= 32'h00000000;
                end
            end
        end else begin
            dyt_sram[dyt_sram_w_row][dyt_sram_w_col] <= dyt_sram_w_data_0;
        end
    end

    // Read Logic from the SRAM
    assign dyt_sram_r_data_0    = dyt_sram[dyt_sram_r_row][dyt_sram_r_col];

endmodule

