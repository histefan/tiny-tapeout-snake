/*
`include "vga_sync.v"
`include "random_position.v"
`include "draw_border.v"
`include "draw_apple.v"
`include "draw_snake.v"
`include "snake_control.v"
`include "collision.v"
`include "rgb_select.v"

*/

`default_nettype none

module snake #(
    parameter BIT = 10
) (
    input wire clk,
    input wire reset,
    input wire up,
    input wire down,
    input wire left,
    input wire right,
    output wire [2:0] rgb_out,
    output reg h_sync_o,
    output reg v_sync_o 
);

wire h_sync, v_sync, active;
wire [BIT-1:0] x_pos, y_pos;

vga_sync #(
    .BIT(BIT),
    .HRES(640),
    .VRES(480),
    .H_FRONT_PORCH(16),
    .H_SYNC(96),
    .H_BACK_PORCH(48),
    .V_FRONT_PORCH(10),
    .V_BACK_PORCH(33),
    .V_SYNC(2)
) sync_signal_gen (
    .clk(clk),
    .reset(reset),
    .h_sync(h_sync),
    .v_sync(v_sync),
    .x_pos(x_pos),
    .y_pos(y_pos),
    .active(active)
);

wire [2:0] rgb_select_out;

rgb_select colour_out (
    .reset(reset),
    .active(active),
    .active_border(border_active),
    .active_apple(apple_active),
    .active_snake_head(snake_head_active),
    .active_snake_body(snake_body_active),
    .rgb_border(rgb_border),
    .rgb_apple(rgb_apple),
    .rgb_snake(rgb_snake),
    .rgb_out(rgb_select_out)
);

assign rgb_out = (active) ? rgb_select_out : 3'b000;

// Register syncs to align with output data.
always @(posedge clk)
begin
    v_sync_o <= v_sync;
    h_sync_o <= h_sync;
end

wire border_active;
wire[2:0] rgb_border;

draw_border game_border (
    .x_pos(x_pos),
    .y_pos(y_pos),
    .border_active(border_active),
    .rgb(rgb_border)
);

wire rand_trigger;
reg apple_trigger, next_apple_trigger;
wire[BIT-1:0] apple_x, apple_y;

random_position apple_pos(
    .clk(clk),
    .reset(reset),
    .new_number_trigger(rand_trigger),
    .x_out(apple_x),
    .y_out(apple_y)
);

wire apple_active;
wire[2:0] rgb_apple;

draw_apple game_apple (
    .x_pos(x_pos),
    .y_pos(y_pos),
    .x_start(apple_x),
    .y_start(apple_y),
    .apple_active(apple_active),
    .rgb(rgb_apple) 
);

wire[2:0] snake_direction;

snake_control game_control (
    .clk(clk),
    .reset(reset),
    .up(up),
    .down(down),
    .left(left),
    .right(right),
    .direction(snake_direction)
);

wire snake_head_active, snake_body_active;
wire [2:0] rgb_snake;

draw_snake game_snake (
    .x_pos(x_pos),
    .y_pos(y_pos),
    .direction(snake_direction),
    .snake_head_active(snake_head_active),
    .snake_body_active(snake_body_active),
    .rgb(rgb_snake) 
);

wire [1:0] collision_state;

collision game_collision (
    .clk(clk),
    .reset(reset),
    .border_active(border_active),
    .apple_active(apple_active),
    .snake_head_active(snake_head_active),
    .snake_body_active(snake_body_active),
    .state_o(collision_state)
);


//state machine
localparam IDLE = 2'b00;
localparam PLAY = 2'b01;
localparam GAME_OVER = 2'b11;

// collision trigger signal
localparam COLLISION = 2'b01;
localparam APPLE_COLLECTED = 2'b10;

reg[1:0] state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        apple_trigger <= 1'b0;
    end else begin
        state <= next_state;
        apple_trigger <= next_apple_trigger;
    end 
end

always @(state, up, down, left, right, collision_state, apple_trigger) begin
    next_state = state;
    next_apple_trigger = apple_trigger;
    if (up || down || left || right) begin
        next_state = PLAY;
    end
    if (collision_state == COLLISION) begin
        next_state = GAME_OVER;
    end
    if (collision_state == APPLE_COLLECTED) begin
        next_apple_trigger = 1'b1;
    end else begin
        next_apple_trigger = 1'b0;
    end
    if (state == GAME_OVER) begin
        next_state = IDLE;
    end 
end

assign rand_trigger = apple_trigger;


endmodule

