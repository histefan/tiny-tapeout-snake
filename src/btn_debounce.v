`default_nettype none

//simple debouncer for push buttons

module btn_debounce (
    input wire clk,
    input wire reset,
    input wire btn_in,
    output wire btn_out
);

parameter COUNTER_BIT = 18;
parameter COUNTER_VAL = 5;

reg [COUNTER_BIT-1:0] counter, next_counter;
reg btn, next_btn;


always @(posedge clk) begin: register_process
    if (reset) begin
        counter <= {COUNTER_BIT{1'b0}};
        btn <= 1'b0;
    end else begin
        counter <= next_counter;
        btn <= next_btn;
    end
end

always @(counter, btn, btn_in) begin: combinatorics
    next_counter = counter;
    next_btn = btn;
    if (btn_in) begin
        next_counter = counter + 1'b1;
        if (counter == COUNTER_VAL) begin
            next_btn = 1'b1;
        end
    end else begin
        next_counter = {COUNTER_BIT{1'b0}};
        next_btn = 1'b0;
    end 
end

assign btn_out = btn;
        

endmodule

