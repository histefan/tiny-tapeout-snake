module draw_snake #(
    parameter SIZE = 5,
    parameter BIT = 10,
    parameter X_START = 320, // start position of snake
    parameter Y_START = 240
) (
    input wire clk,
    input wire reset,
    input wire update,
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
/*
integer count1, count2, count3;
reg [BIT-1:0] snakeX[0:31];
reg [BIT-1:0] snakeY[0:31];
reg [BIT-1:0] next_snakeX[0:31];
reg [BIT-1:0] next_snakeY[0:31];
*/
reg[4:0] size, next_size;
//reg head, next_head, body, next_body;
//integer i;
integer i;
reg [BIT-1:0] snakeX, next_snakeX, snakeY, next_snakeY; // , bodyX1, bodyX2, next_bodyX1, next_bodyX2;//, bodyX3, bodyX4, bodyX5, bodyX6, bodyX7, bodyX8, bodyX9, bodyX10, bodyX11, bodyX12, bodyX13, bodyX14, bodyX15;
reg [BIT-1:0] bodyX [0:31];
reg [BIT-1:0] bodyY [0:31];
reg [BIT-1:0] next_bodyX [0:31];
reg [BIT-1:0] next_bodyY [0:31];  //, next_bodyX1, next_bodyX2;
always @(posedge clk) begin
    if (reset) begin
        size <= 5'b00001;
        snakeX <= X_START;
        snakeY <= Y_START;
         for (i = 0; i < 32; i = i+1) begin
            bodyX[i] <= 700;
            bodyY[i] <= 500;   
        end        
    end else begin
        snakeX <= next_snakeX;
        snakeY <= next_snakeY;
        for (i = 0; i < 32; i = i+1) begin
            bodyX[i] <= next_bodyX[i];
            bodyY[i] <= next_bodyY[i];   
        end
        size <= next_size;
    end
end

always @(snakeX, snakeY, size, game_state, direction, update, bodyX[0], bodyY[0]) begin
    next_snakeX = snakeX;
    next_snakeY = snakeY;
    for (i = 0; i < 32; i = i+1) begin
            next_bodyX[i] = bodyX[i];
            next_bodyY[i] = bodyY[i];   
    end
    
    next_size = size;
    if (game_state == PLAY && update) begin
            // shift values in register
            case (direction) // direction of head
            UP: next_snakeY = (snakeY - SIZE);
            DOWN: next_snakeY = (snakeY + SIZE);
            LEFT : next_snakeX = (snakeX - SIZE);
            RIGHT: next_snakeX = (snakeX + SIZE);
            IDLE: begin 
                    next_snakeY = snakeY;
                    next_snakeX = snakeX;
                  end
            default:begin 
                    next_snakeY = snakeY;
                    next_snakeX = snakeX;
                  end
        endcase 
        for (i = 1; i < 32; i = i+1) begin
            next_bodyX[i] = bodyX[i-1];
            next_bodyY[i] = bodyY[i-1];   
        end
        next_bodyX[0] = snakeX;
        next_bodyY[0] = snakeY;
        
    end     
    if (game_state == GAME_OVER)  begin  
        //initialise snake head
        next_size = 5'b00010;
        next_snakeX = X_START;
        next_snakeY = Y_START;    
    end    
end

assign snake_head_active = (x_pos >= snakeX) && (x_pos < snakeX + SIZE) && (y_pos >= snakeY) && (y_pos < snakeY + SIZE);
//assign snake_head_active = (x_pos >= snakeX) && (x_pos < snakeX + SIZE) && (y_pos >= snakeY) && (y_pos < snakeY + SIZE);
assign snake_body_active = (x_pos >= bodyX[0]) && (x_pos < bodyX[0] + SIZE) && (y_pos >= bodyY[0]) && (y_pos < bodyY[0] + SIZE) || (x_pos >= bodyX[1]) && (x_pos < bodyX[1] + SIZE) && (y_pos >= bodyY[1]) && (y_pos < bodyY[1] + SIZE);
assign rgb = snake_rgb;


/*

reg[9:0] snake_x_reg [127:0];
reg[9:0] snake_y_reg [127:0];
reg[9:0] next_snake_x_reg [127:0];
reg[9:0] next_snake_y_reg [127:0];
reg snake_body_reg [127:0];
reg next_snake_body_reg [127:0];



reg [BIT-1:0] x_delta, next_x_delta, y_delta, next_y_delta;
reg [BIT-1:0] x_start, next_x_start, y_start, next_y_start;
reg [BIT-1:0] next_x_body_delta, next_y_body_delta;

wire snake_body_active_up, snake_body_active_down, snake_body_active_left, snake_body_active_right;



always @(posedge clk) begin
    if (reset) begin
        x_delta <= {BIT{1'b0}};
        y_delta <= {BIT{1'b0}};
        x_start <= X_START;
        y_start <= Y_START;
        //snake_x_reg <= '{default: {BIT{1'b0}}};
        //snake_y_reg <= '{default: {BIT{1'b0}}};
        
    end else begin
        x_delta <= next_x_delta;
        y_delta <= next_y_delta;
        x_start <= next_x_start;
        y_start <= next_y_start;
        //snake_x_reg <= next_snake_x_reg;
        //snake_y_reg <= next_snake_y_reg;
  
    end
    
end
   
always @(y_pos, x_delta, y_delta, x_start, y_start, direction, game_state) begin
    next_x_delta = {BIT{1'b0}};
    next_y_delta = {BIT{1'b0}};
    next_x_start = x_start;
    next_y_start = y_start;
    //next_snake_x_reg[126:0] = snake_x_reg[127:1];
    //next_snake_x_reg[127] = x_start + 10; 
    //next_snake_y_reg[126:0] = snake_y_reg[127:1];
    //next_snake_y_reg[127] = y_start + 10; 

    
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

assign snake_body_active_left = (x_pos >= x_start + SIZE) && (x_pos < x_start + SIZE + SPEED) && (y_pos >= y_start) && (y_pos < y_start + SIZE) && direction == LEFT;

assign snake_body_active_up =  (x_pos >= x_start) && (x_pos < x_start + SIZE) && (y_pos >= y_start + SIZE) && (y_pos < y_start + SIZE + SPEED) && direction == UP;
assign snake_body_active = snake_body_active_up || snake_body_active_left;

//assign snake_body_active = snake_body_active_up || snake_body_active_down || snake_body_active_left || snake_body_active_right; 

//(x_pos >= x_start + SIZE) && (x_pos < x_start + SIZE + SPEED) && (y_pos >= y_start) && (y_pos < y_start + SIZE);
*/
/*
assign snake_head_active = 1'b0;
assign snake_body_active = 1'b0;
*/
endmodule
