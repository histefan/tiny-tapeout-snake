`default_nettype none

module tt_um_histefan_top #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire reset = ! rst_n;    
    /*

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
    */
    
    
snake snake_game (
    .clk(clk),
    .reset(reset),
    .up(ui_in[7]),
    .down(ui_in[6]),
    .left(ui_in[5]),
    .right(ui_in[4]),
    .rgb_out(uo_out[7:5]),
    .h_sync_o(uo_out[4]),
    .v_sync_o(uo_out[3])
);

endmodule
