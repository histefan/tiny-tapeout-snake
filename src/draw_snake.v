module draw_snake #(
    parameter SIZE = 15,
    parameter BIT = 10,
    parameter X_START = 320, // start position of snake
    parameter Y_START = 240,
    parameter SPEED = 2
) (
    input wire clk,
    input wire reset,
    input wire update,
    input wire[BIT-1:0] x_pos,
    input wire[BIT-1:0] y_pos, 
    input wire [2:0] direction,
    input wire [1:0] collision,
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

localparam APPLE_COLLECTED = 2'b10;

//states game
localparam PLAY = 2'b01;
localparam GAME_OVER = 2'b11;

reg [BIT-1:0] snakeX, next_snakeX, snakeY, next_snakeY; 
reg [BIT-1:0] speed, next_speed;

reg apple, next_apple;

always @(posedge clk) begin
    if (reset) begin
        //size <= 5'b00001;
        snakeX <= X_START;
        snakeY <= Y_START;   
        apple <= 1'b0;
        speed <= SPEED;
        
    end else begin
        snakeX <= next_snakeX;
        snakeY <= next_snakeY;
        speed <= next_speed;
        apple <= next_apple;
      
    end
end

always @(snakeX, snakeY, game_state, direction, update, apple, speed, collision) begin
    next_snakeX = snakeX;
    next_snakeY = snakeY;
    next_speed = speed;
    next_apple = apple;

    
    if (collision == APPLE_COLLECTED && apple == 1'b0) begin
        next_apple = 1'b1;
    end 
    if (collision != APPLE_COLLECTED) begin
       next_apple = 1'b0;  
    end
    if (apple) begin
        next_speed = speed +1;
    end  
    
    if (game_state == PLAY && update) begin
            // shift values in register
            case (direction) // direction of head
            UP: next_snakeY = (snakeY - speed);
            DOWN: next_snakeY = (snakeY + speed);
            LEFT : next_snakeX = (snakeX - speed);
            RIGHT: next_snakeX = (snakeX + speed);
            IDLE: begin 
                    next_snakeY = snakeY;
                    next_snakeX = snakeX;
                  end
            default:begin 
                    next_snakeY = snakeY;
                    next_snakeX = snakeX;
                  end
        endcase 
        
        
    end     
    if (game_state == GAME_OVER)  begin  
        //initialise snake head
        next_snakeX = X_START;
        next_snakeY = Y_START;
        next_speed = SPEED;
        next_apple = 1'b0; 
          
    end 
end

assign snake_head_active = (x_pos >= snakeX) && (x_pos < snakeX + SIZE) && (y_pos >= snakeY) && (y_pos < snakeY + SIZE);
assign snake_body_active = 1'b0;
assign rgb = snake_rgb;



endmodule
