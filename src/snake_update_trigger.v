module snake_update_trigger #(
    parameter BIT = 10,
    parameter V_SYNC_COUNT = 490,
    parameter H_SYNC_COUNT = 656,
    parameter COUNTER = 1 // trigger update when this value is reached
) (
    input wire clk,
    input wire reset,
    input wire[BIT-1:0] x_pos,
    input wire[BIT-1:0] y_pos,
    output wire update_trigger

);

reg[7:0] cnt, next_cnt;
reg update, next_update;
// generate update trigger for drawing next position of snake
always @(posedge clk) begin
    if (reset) begin
        cnt <= 8'b00000000;
        update <= 1'b0;
    end else begin
        cnt <= next_cnt;
        update <= next_update;
    end
end

always @(cnt, y_pos, x_pos, update) begin
    next_cnt = cnt;
    next_update = update;
    if (y_pos == V_SYNC_COUNT && x_pos == H_SYNC_COUNT) begin
        next_cnt = cnt + 8'b00000001;
    end
    if (cnt == COUNTER && update == 1'b0) begin
        next_update = 1'b1;
        next_cnt = 8'b00000000;
    end else begin
        next_update = 1'b0;
    end   
end

assign update_trigger = update;

endmodule
