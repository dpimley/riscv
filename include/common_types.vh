/*
Description: Shared types folder that will make life easier

Author: Yash Bharatula
*/

package common_types;

// word width and size
parameter WORD_W    = 32;
parameter WBYTES    = WORD_W/8;

// word_t
typedef logic [WORD_W-1:0] word_t;

