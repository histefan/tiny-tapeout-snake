module draw_snake #(
    parameter SIZE = 25,
    parameter BIT = 10,
    parameter X_START = 300, // start position of snake
    parameter Y_START = 300
) (
    input wire[BIT-1:0] x_pos,
    input wire[BIT-1:0] y_pos, 
    input wire [2:0] direction,  
    output wire snake_head_active,
    output wire snake_body_active,
    output wire [2:0] rgb
);

parameter snake_rgb = 3'b010; // green

assign snake_head_active = (x_pos >= X_START) && (x_pos < X_START + SIZE) && (y_pos >= Y_START) && (y_pos < Y_START + SIZE);
assign snake_body_active = 1'b0;
assign rgb = snake_rgb;



endmodule
