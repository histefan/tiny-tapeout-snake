

module draw_border # (
    parameter BIT = 10
) (
    input wire[BIT-1:0] x_pos,
    input wire[BIT-1:0] y_pos,
    output wire border_active,
    output wire [2:0] rgb
);

parameter BORDER_LEFT = 10'd0;
parameter BORDER_RIGHT = 10'd639;
parameter BORDER_BOTTOM = 10'd479;
parameter BORDER_TOP = 10'd0;
parameter BORDER_BIT_WIDTH = 4;
parameter color = 3'b111; // white


assign border_active = x_pos[BIT-1: BORDER_BIT_WIDTH] == BORDER_LEFT[BIT-1: BORDER_BIT_WIDTH] || x_pos[BIT-1: BORDER_BIT_WIDTH] == BORDER_RIGHT[BIT-1: BORDER_BIT_WIDTH] || y_pos[BIT-1: BORDER_BIT_WIDTH] == BORDER_TOP[BIT-1: BORDER_BIT_WIDTH] || y_pos[BIT-1: BORDER_BIT_WIDTH] == BORDER_BOTTOM[BIT-1: BORDER_BIT_WIDTH];

assign rgb = color;

endmodule
