module draw_snake #(
    parameter SIZE = 10,
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
//localparam GAME_OVER = 2'b11;

integer count1, count2, count3;
reg [BIT-1:0] snakeX[0:31];
reg [BIT-1:0] snakeY[0:31];
reg [BIT-1:0] next_snakeX[0:31];
reg [BIT-1:0] next_snakeY[0:31];
reg[4:0] size, next_size;
reg head, next_head, body, next_body;
integer i;

//reg [BIT-1:0] snakeX, next_snakeX, snakeY, next_snakeY, body1, body2, body3, body4, body5, body6, body7, body8, body9, body10, body11, body12

always @(posedge clk) begin
    if (reset) begin
       for(count3 = 1; count3 > 32; count3 = count3 + 1) begin
           //initialse body of snake outside visible area on screen
           snakeX[count3] <= 700;
           snakeY[count3] <= 500;
        end
        size <= 5'b00001;
        snakeX[0] <= X_START;
        snakeY[0] <= Y_START; 
        head <= ((x_pos >= snakeX[0] && x_pos < snakeX[0] + SIZE) && (y_pos >= snakeY[0] && y_pos < snakeY[0] + SIZE));  
        body <= 1'b0;   
    end else begin
        for (i = 0; i < 32; i = i + 1) begin     
            snakeX[i] <= next_snakeX[i];
            snakeY[i] <= next_snakeY[i];
        end
        size <= next_size;
        head <= next_head;
        body <= next_body;
    end
end
    
always @(snakeX[0], snakeY[0], size, game_state, direction, update, head, body, x_pos, y_pos) begin

   for (i = 0; i < 32; i = i + 1) begin     
        next_snakeX[i] = snakeX[i];
        next_snakeY[i] = snakeY[i];
    end
    next_size = size;
    next_head = head;
    next_body = body;

    if (game_state == PLAY && update) begin
        if (direction != IDLE) begin
            // shift values in register
            for (count1 = 31; count1 > 0; count1 = count1 - 1) begin
                if (count1 <= size-1) begin
                    next_snakeX[count1] = snakeX[count1 - 1];
                    next_snakeY[count1] = snakeX[count1 - 1];
                end
            end 
                case (direction) // direction of head
            UP: next_snakeY[0] = (snakeY[0] - SIZE);
            DOWN: next_snakeY[0] = (snakeY[0] + SIZE);
            LEFT : next_snakeX[0] = (snakeX[0] - SIZE);
            RIGHT: next_snakeX[0] = (snakeX[0] + SIZE);
            IDLE: begin 
                    next_snakeY[0] = snakeY[0];
                    next_snakeX[0] = snakeX[0];
                  end
            default: begin 
                    next_snakeY[0] = snakeY[0];
                    next_snakeX[0] = snakeX[0];
                  end
        endcase
        end
        
        case (direction) // direction of head
            UP: next_snakeY[0] = (snakeY[0] - SIZE);
            DOWN: next_snakeY[0] = (snakeY[0] + SIZE);
            LEFT : next_snakeX[0] = (snakeX[0] - SIZE);
            RIGHT: next_snakeX[0] = (snakeX[0] + SIZE);
            IDLE: begin 
                    next_snakeY[0] = snakeY[0];
                    next_snakeX[0] = snakeX[0];
                  end
            default: begin 
                    next_snakeY[0] = snakeY[0];
                    next_snakeX[0] = snakeX[0];
                  end
        endcase
        next_head = ((x_pos >= snakeX[0] && x_pos < snakeX[0] + SIZE) && (y_pos >= snakeY[0] && y_pos < snakeY[0] + SIZE));    
        
    end else begin
        for(count3 = 1; count3 > 32; count3 = count3 + 1) begin
            //initialise body of snake outside visible area on screen
            next_snakeX[count3] = 700;
            next_snakeY[count3] = 500;
        end
        //initialise snake head
        next_size = 5'b00010;
        next_snakeX[0] = X_START;
        next_snakeY[0] = Y_START;    
    end

        //next_head = ((x_pos >= snakeX[0] && x_pos < snakeX[0] + SIZE) && (y_pos >= snakeY[0] && y_pos < snakeY[0] + SIZE));


    next_body = 1'b0; 
    for (count2 = 1; count2 < size; count2 = count2 +1) begin
        if (body == 1'b0) begin
            next_body = ((x_pos > snakeX[count2] && x_pos < snakeX[count2] + SIZE) && (y_pos > snakeY[count2] && y_pos < snakeY[count2] + SIZE));
        end
    end
    
end

//assign snake_head_active = (x_pos >= x_start) && (x_pos < x_start + SIZE) && (y_pos >= y_start) && (y_pos < y_start + SIZE);
//assign snake_body_active_left = (x_pos >= x_start + SIZE) && (x_pos < x_start + SIZE + SPEED) && (y_pos >= y_start) && (y_pos < y_start + SIZE) && direction == LEFT;

//assign snake_body_active_up =  (x_pos >= x_start) && (x_pos < x_start + SIZE) && (y_pos >= y_start + SIZE) && (y_pos < y_start + SIZE + SPEED) && direction == UP;
assign snake_head_active = ((x_pos >= snakeX[0] && x_pos < snakeX[0] + SIZE) && (y_pos >= snakeY[0] && y_pos < snakeY[0] + SIZE));
assign snake_body_active = body;
assign rgb = snake_rgb;

/*
always @(posedge clk) begin
    if (reset) begin
        snake_body <= 1'b0;
    end else begin
        snake_body <= 0;
        for (count2 = 1; count2 < size; count2 = count2 +1) begin
            if (snake_body == 1'b0) begin
            snake_body <= ((x_pos > snakeX[count2] && x_pos < snakeX[count2] + SIZE) && (y_pos > snakeY[count2] && y_pos < snakeY[count2] +SIZE));
            end
        end
    end
end

reg snake_head;

always @(posedge clk) begin
 if (reset) begin
        snake_head <= 1'b0;
    end else begin
        snake_head <= ((x_pos > snakeX[0] && x_pos < snakeX[0] + SIZE) && (y_pos > snakeY[0] && y_pos < snakeY[0] +SIZE));
    end
end 
*/








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
