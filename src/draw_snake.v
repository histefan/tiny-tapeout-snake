module draw_snake #(
    parameter SIZE = 25,
    parameter BIT = 10,
    parameter X_START = 320, // start position of snake
    parameter Y_START = 240,
    // counter value at begin of sync signal 
    parameter V_SYNC_COUNT = 490,
    parameter SPEED = 35 // px/hz
) (
    input wire clk,
    input wire reset,
    input wire[BIT-1:0] x_pos,
    input wire[BIT-1:0] y_pos, 
    input wire [2:0] direction,
    input wire [1:0] game_state,  
    output wire snake_head_active,
    output wire snake_body_active,
    output wire [2:0] rgb
);

parameter snake_rgb = 3'b010; // green

// states control
localparam IDLE = 3'b000;
localparam UP = 3'b001;
localparam DOWN = 3'b010;
localparam LEFT = 3'b011;
localparam RIGHT = 3'b100;

//states game
localparam PLAY = 2'b01;
localparam GAME_OVER = 2'b11;

reg [BIT-1:0] x_delta, next_x_delta, y_delta, next_y_delta;
reg [BIT-1:0] x_start, next_x_start, y_start, next_y_start;

always @(posedge clk) begin
    if (reset) begin
        x_delta <= {BIT{1'b0}};
        y_delta <= {BIT{1'b0}};
        x_start <= X_START;
        y_start <= Y_START;
    end else begin
        x_delta <= next_x_delta;
        y_delta <= next_y_delta;
        x_start <= next_x_start;
        y_start <= next_y_start;
    end
    
end


   
always @(y_pos, x_delta, y_delta, x_start, y_start, direction, game_state) begin
    next_x_delta = {BIT{1'b0}};
    next_y_delta = {BIT{1'b0}};
    next_x_start = x_start;
    next_y_start = y_start;
    if ((y_pos == V_SYNC_COUNT) && (game_state == PLAY)) begin
        case (direction)
            UP: next_y_delta = -SPEED;
            DOWN: next_y_delta = SPEED;
            LEFT : next_x_delta = -SPEED;
            RIGHT: next_x_delta = SPEED;
            IDLE: begin 
                    next_x_delta = {BIT{1'b0}};
                    next_y_delta = {BIT{1'b0}};
                  end
            default: begin 
                    next_x_delta = {BIT{1'b0}};
                    next_y_delta = {BIT{1'b0}};
                  end
        endcase
        
        // only increase x,y position once
        if ((x_delta == {BIT{1'b0}}) || (x_delta == {BIT{1'b0}})) begin
            next_x_start = x_start + next_x_delta;
        end       
        if ((y_delta == {BIT{1'b0}}) || (y_delta =={BIT{1'b0}})) begin 
            next_y_start = y_start + next_y_delta;
        end     
    end
    if (game_state == GAME_OVER) begin
         next_x_delta = {BIT{1'b0}};
         next_y_delta = {BIT{1'b0}};
         next_x_start = X_START;
         next_y_start = Y_START;    
    end   
end 



assign snake_head_active = (x_pos >= x_start) && (x_pos < x_start + SIZE) && (y_pos >= y_start) && (y_pos < y_start + SIZE);
assign snake_body_active = 1'b0;
assign rgb = snake_rgb;



endmodule
