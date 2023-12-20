module draw_apple # (
    parameter BIT = 10,
    parameter SIZE = 10 // size of apple in px
) (
    input wire[BIT-1:0] x_pos,
    input wire[BIT-1:0] y_pos,
    input wire[BIT-1:0] x_start,
    input wire[BIT-1:0] y_start,   
    output wire apple_active,
    output wire [2:0] rgb
);

parameter color = 3'b100; // red

assign apple_active = (x_pos >= x_start) && (x_pos < x_start + SIZE - 1) && (y_pos >= y_start) && (y_pos < y_start + SIZE-1);
assign rgb = color;

endmodule
