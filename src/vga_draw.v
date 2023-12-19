module vga_draw
#(
    parameter BIT = 10, // ceil(maxPx=800) 
    parameter[BIT-1:0] HRES = 640,
    parameter[BIT-1:0] VRES = 480,
    parameter[BIT-1:0] H_FRONT_PORCH = 16,
    parameter[BIT-1:0] H_SYNC = 96,
    parameter[BIT-1:0] H_BACK_PORCH = 48,
    parameter[BIT-1:0] V_FRONT_PORCH = 10,
    parameter[BIT-1:0] V_BACK_PORCH = 33,
    parameter[BIT-1:0] V_SYNC = 2
) (
    input wire clk, // 25.179 MHz 
    input wire reset,
    output wire red_o,
    output wire grn_o,
    output wire blu_o,
    output reg v_sync_o,
    output reg h_sync_o
);

vga_sync #(
    .BIT(BIT),
    .HRES(HRES),
    .VRES(VRES),
    .H_FRONT_PORCH(H_FRONT_PORCH),
    .H_SYNC(H_SYNC),
    .H_BACK_PORCH(H_BACK_PORCH),
    .V_FRONT_PORCH(V_FRONT_PORCH),
    .V_BACK_PORCH(V_BACK_PORCH),
    .V_SYNC(V_SYNC)
) sync_signal_gen (
    .clk(clk),
    .reset(reset),
    .h_sync(h_sync),
    .v_sync(v_sync),
    .x_pos(x_pos),
    .y_pos(y_pos),
    .active(active)
);

wire h_sync, v_sync, active;
wire [BIT-1:0] x_pos, y_pos;

// Register syncs to align with output data.
always @(posedge clk)
begin
    v_sync_o <= v_sync;
    h_sync_o <= h_sync;
end


// border drawing 
wire[2:0] border_rgb;
wire border_r, border_g, border_b;
wire border_active;

draw_border border (
    .x_pos(x_pos),
    .y_pos(y_pos),
    .border_active(border_active),
    .rgb(border_rgb)  
);

  assign border_r = (active && border_active) ? border_rgb[2] : 1'b0;
  assign border_g = (active && border_active) ? border_rgb[1] : 1'b0;
  assign border_b = (active && border_active) ? border_rgb[0] : 1'b0;


// apple drawing
wire[2:0] apple_rgb;
wire apple_r, apple_g, apple_b;
wire apple_active;

draw_apple apple (
    .x_pos(x_pos),
    .y_pos(y_pos),
    .x_start(10'd0),
    .y_start(10'd0),
    .apple_active(apple_active),
    .rgb(apple_rgb)  
);

  assign apple_r = (active && apple_active) ? apple_rgb[2] : 1'b0;
  assign apple_g = (active && apple_active) ? apple_rgb[1] : 1'b0;
  assign apple_b = (active && apple_active) ? apple_rgb[0] : 1'b0;
  
reg r,g,b;
  
  always @(border_r, border_g, border_b, apple_r, apple_g, apple_b, x_pos, y_pos, h_sync, v_sync) begin : color_comb
      r <= 1'b0;
      g <= 1'b0;
      b <= 1'b0;
      if (active) begin
        if (apple_active) begin
           r <= apple_r;
           g <= apple_g;
           b <= apple_b;
        end
        if (border_active) begin
           r <= border_r;
           g <= border_g;
           b <= border_b; 
       end 
     end
  end
  
  
  assign red_o = r;
  assign grn_o = g;
  assign blu_o = b;



  
endmodule
