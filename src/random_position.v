/*
simple non random number generator by using clk signal and counters
*/

`default_nettype none

module random_position #(
    parameter BIT = 10,
    parameter MIN_X = 40,
    parameter MAX_X = 600,
    parameter MIN_Y = 40,
    parameter MAX_Y = 440
) (
    input wire clk,
    input wire reset,
    input wire new_number_trigger,
    output wire[BIT-1:0] x_out,
    output wire[BIT-1:0] y_out
);


reg[BIT-1:0] x, next_x, y, next_y, saved_x, next_saved_x, saved_y, next_saved_y;
reg new_num;

always @(posedge clk) begin
    if (reset) begin
        x <= {BIT{1'b0}};
        y <= {BIT{1'b0}};
        saved_x <= 60; // start position always the same
        saved_y <= 100;
        new_num <= 1'b0;
    end else begin
        x <= next_x;
        y <= next_y;
        saved_x <= next_saved_x;
        saved_y <= next_saved_y;
        new_num <= new_number_trigger;
    end
end

always @(x,y, new_number_trigger, new_num, saved_x, saved_y) begin
    next_x = x;
    next_y = y; 
    next_saved_x = saved_x;
    next_saved_y = saved_y;
    if (x < MIN_X || x >= MAX_X-1 ) begin
        next_x = MIN_X;
    end else begin
        next_x = x + 2;
    end
    
    if ( y < MIN_Y || y >= MAX_Y-1 ) begin
        next_y = MIN_Y;
    end else begin
        next_y = y + 1'b1;
    end  
    if (new_number_trigger & ~new_num) begin // edge detection of new number trigger
      next_saved_x = x;
      next_saved_y = y;
    end 
   
end

assign x_out = saved_x;
assign y_out = saved_y;

endmodule
