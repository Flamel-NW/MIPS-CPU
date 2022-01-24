//
//-------------------------------------------------------------------------------------------------
// This is an example to show you how to write simple Verilog HDL program.
// Copy right belongs to SCSE of BUAA, 2013
//-------------------------------------------------------------------------------------------------
// Title        : Newspaper vending machine
// Author       : Gao Xiaopeng (gxp@buaa.edu.cn)
//-------------------------------------------------------------------------------------------------
// Description  : 
// Note         : 
//-------------------------------------------------------------------------------------------------

module vend_ctrl( coin, clock, reset, newspaper ) ;
    input   [1:0]   coin ;                              // XXXX
    input           clock ;                             // system clock
    input           reset ;                             // synchronous reset
    output          newspaper ;                         // XXXX
    wire            newspaper ;                         
    
    // variables declaration
    reg     [1:0]   fsm_state ;                         // XXXX
    
    // codes of state mechine
    parameter   S0  = 2'b00 ;                           // XXXX
    parameter   S5  = 2'b01 ;                           // XXXX
    parameter   S10 = 2'b10 ;                           // XXXX
    parameter   S15 = 2'b11 ;                           // XXXX
    // XXXX
    parameter   COIN_0  = 2'b00 ;                       // XXXX
    parameter   COIN_5  = 2'b01 ;                       // XXXX
    parameter   COIN_10 = 2'b10 ;                       // XXXX

    // 
    assign  newspaper = (fsm_state == S15) ;            // XXXX
    
    //
    always  @( posedge clock )
        if ( reset )
            fsm_state <= S0 ;                                           // XXXX
        else
            case ( fsm_state ) 
                S0  :   if      ( coin == COIN_5 )  fsm_state <= S5 ;   // S0 --> S5 : get a 5-cent coin
                        else if ( coin == COIN_10 ) fsm_state <= S10 ;  // XXXX
                S5  :   if      ( coin == COIN5 )   fsm_state <= S10 ;  // XXXX
                        else if ( coin == COIN10 )  fsm_state <= S15 ;  // XXXX
                S10 :   if      ( coin == COIN_5 )  fsm_state <= S15 ;  // XXXX
                        else if ( coin == COIN_10 ) fsm_state <= S15 ;  // XXXX
                S15 :   fsm_state  <= S0 ;                              // XXXX
                default : fsm_state <= S0 ;                             // XXXX
            endcase

endmodule