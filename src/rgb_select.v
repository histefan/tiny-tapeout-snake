`default_nettype none

module rgb_select (
    input wire reset,
    input wire active,
    input wire active_border,
    input wire active_apple,
    input wire active_snake_head,
    input wire active_snake_body,
    input wire [2:0] rgb_border,
    input wire [2:0] rgb_apple,
    input wire [2:0] rgb_snake,
    output reg[2:0] rgb_out
);

// select color to display on screen 
always @(*) begin
    rgb_out = 3'b000;
    if (active && !reset) begin
        if (active_apple) begin
            rgb_out = rgb_apple;
        end
        if (active_snake_head || active_snake_body) begin
            rgb_out = rgb_snake;
        end
        if (active_border) begin
            rgb_out = rgb_border;
        end   
    end 

end

endmodule
