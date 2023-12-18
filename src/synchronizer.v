`default_nettype none

//synchronizer with 2 FF

module synchronizer (
    input wire clk,
    input wire reset,
    input wire async_in,
    output wire sync_out 
);

reg sync_ff1;
reg sync_ff2;

always @(posedge clk) begin
    if (reset) begin
        sync_ff1 <= 1'b0;
        sync_ff2 <= 1'b0;
    end else begin
        sync_ff1 <= async_in;
        sync_ff2 <= sync_ff1;
    end
end

assign sync_out = sync_ff2;

endmodule
    
        
