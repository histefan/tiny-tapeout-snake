`default_nettype none

module vga_driver
#(
    parameter HRES = 640,
    parameter VRES = 480,
    parameter[9:0] H_FRONT_PORCH = 16,
    parameter[9:0] H_SYNC = 96,
    parameter[9:0] H_BACK_PORCH = 48,
    parameter[9:0] V_FRONT_PORCH = 11,
    parameter[9:0] V_BACK_PORCH = 2,
    parameter[9:0] V_SYNC = 31
) (
    input wire clk, // 25.179 MHz 
    input wire reset,
    output wire h_sync,
    output wire v_sync,
    
);


always @(posedge clk) begin
    if (reset) begin
    
    end else begin
    
    end 

end



endmodule
