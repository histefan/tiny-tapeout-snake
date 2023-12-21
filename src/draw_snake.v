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
    //input wire [2:0] collision,
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

integer i,j,k,l,m,n;
reg [BIT-1:0] snakeX, next_snakeX, snakeY, next_snakeY; 
reg [BIT-1:0] bodyX [0:7];
reg [BIT-1:0] bodyY [0:7];
reg [BIT-1:0] next_bodyX [0:7];
reg [BIT-1:0] next_bodyY [0:7];  //, next_bodyX1, next_bodyX2;
reg body_active, next_body_active;
reg [7:0] body_size, next_body_size;
reg head_active, next_head_active;

always @(posedge clk) begin
    if (reset) begin
        //size <= 5'b00001;
        snakeX <= X_START;
        snakeY <= Y_START;
         for (i = 0; i < 8; i = i+1) begin
            bodyX[i] <= 10'd700;
            bodyY[i] <= 10'd500;   
        end    
        body_active <= 1'b0; 
        head_active <= 1'b0;
        body_size <= 8'b00000100;   
    end else begin
        snakeX <= next_snakeX;
        snakeY <= next_snakeY;
        for (k = 0; k < 8; k = k+1) begin
            bodyX[k] <= next_bodyX[k];
            bodyY[k] <= next_bodyY[k];   
        end
        body_active <= next_body_active;
        body_size <= next_body_size;
        head_active <= next_head_active;
       
        //size <= next_size;
    end
end

always @(snakeX, snakeY, game_state, direction, update, bodyX[0], bodyY[0], x_pos, y_pos, body_active, body_size, head_active) begin
    next_snakeX = snakeX;
    next_snakeY = snakeY;
    next_body_active = body_active;
    next_head_active = head_active;
    next_body_size = body_size;
    for (l = 0; l < 8; l = l+1) begin
            next_bodyX[l] = bodyX[l];
            next_bodyY[l] = bodyY[l];   
    end
    
    //next_size = size;
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
        for (j = 1; j < 8; j = j+1) begin
            next_bodyX[j] = bodyX[j-1];
            next_bodyY[j] = bodyY[j-1];   
        end
        next_bodyX[0] = snakeX;
        next_bodyY[0] = snakeY;
        
    end     
    if (game_state == GAME_OVER)  begin  
        //initialise snake head
        //next_size = 5'b00010;
        next_snakeX = X_START;
        next_snakeY = Y_START;
        for (m = 0; m < 8; m = m+1) begin
            next_bodyX[m] = 10'd700;
            next_bodyY[m] = 10'd500;   
        end   
          
    end 
    next_head_active = (x_pos >= snakeX) && (x_pos < snakeX + SIZE) && (y_pos >= snakeY) && (y_pos < snakeY + SIZE);
    /*
     if (x_pos == snakeX && (y_pos >= snakeY && y_pos < snakeY + SIZE)) begin
            next_body_active = 1'b1;      
        end else if (x_pos == snakeX + SIZE || y_pos == snakeY + SIZE) begin
            next_body_active = 1'b0;
        end  
        */
    for (n = 0; n < 8; n = n + 1) begin
        if (x_pos == bodyX[n] + 1 && (y_pos > bodyY[n] && y_pos < bodyY[n] + SIZE - 1) && body_size >= n+1) begin
            next_body_active = 1'b1;      
        end else if (x_pos == bodyX[n] + SIZE - 1|| y_pos == bodyY[n] + SIZE -1) begin
            next_body_active = 1'b0;
        end 
    end 
end

assign snake_head_active = head_active;
assign snake_body_active = body_active;


//temporary
//assign snake_body_active = (x_pos >= bodyX[0]) && (x_pos < bodyX[0] + SIZE) && (y_pos >= bodyY[0]) && (y_pos < bodyY[0] + SIZE) ||
//(x_pos >= bodyX[1]) && (x_pos < bodyX[1] + SIZE) && (y_pos >= bodyY[1]) && (y_pos < bodyY[1] + SIZE);
 /* ||
(x_pos >= bodyX[2]) && (x_pos < bodyX[2] + SIZE) && (y_pos >= bodyY[2]) && (y_pos < bodyY[2] + SIZE) ||
(x_pos >= bodyX[3]) && (x_pos < bodyX[3] + SIZE) && (y_pos >= bodyY[3]) && (y_pos < bodyY[3] + SIZE) ||
(x_pos >= bodyX[4]) && (x_pos < bodyX[4] + SIZE) && (y_pos >= bodyY[4]) && (y_pos < bodyY[4] + SIZE) ||
(x_pos >= bodyX[5]) && (x_pos < bodyX[5] + SIZE) && (y_pos >= bodyY[5]) && (y_pos < bodyY[5] + SIZE) ||
(x_pos >= bodyX[6]) && (x_pos < bodyX[6] + SIZE) && (y_pos >= bodyY[6]) && (y_pos < bodyY[6] + SIZE) ||
(x_pos >= bodyX[7]) && (x_pos < bodyX[7] + SIZE) && (y_pos >= bodyY[7]) && (y_pos < bodyY[7] + SIZE);
*/
/*
always @(x_pos, y_pos) begin
    for (n = 0; n < 8; n = n + 1) begin
        if (x_pos == bodyX[m] && y_pos == bodyY[m]) begin
            snake_body_active <= 1'b1;      
        end else if (x_pos == bodyX[0] + SIZE - 1 && y_pos == bodyY[m] + SIZE - 1) begin
            snake_body_active <= 1'b0;
        end 
    end
end
*/

assign rgb = snake_rgb;




 
endmodule
