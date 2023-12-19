// checks if collision occured and returns if collision occured with border, snake body or with apple

`default_nettype none

module collision (
    input wire clk,
    input wire reset,
    input wire border_active, 
    input wire apple_active,
    input wire snake_head_active,
    input wire snake_body_active,
    output wire [1:0] state_o // 00 reset, 01 collision, 10 apple collected, 11 no collision
);

localparam RESET = 2'b00;
localparam COLLISION = 2'b01;
localparam APPLE_COLLECTED = 2'b10;
localparam NO_COLLISION = 2'b11;

reg[1:0] state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= RESET;
    end else begin
        state <= next_state;
    end
end

always @(state, border_active, apple_active, snake_head_active, snake_body_active) begin
    next_state = state;
    if ((border_active & snake_head_active) || (snake_body_active & snake_head_active)) begin
        next_state = COLLISION;
    end else if (apple_active & snake_head_active) begin
        next_state = APPLE_COLLECTED;
    end else begin
        next_state = NO_COLLISION;
    end
end

assign state_o = state;
        

endmodule
