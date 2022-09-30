module sync_r2w //synchronizer - 2 DFF to synchronize the signal from read to write
    #(
    parameter ADDR_SIZE = 6
    )
    (
    output reg [ADDR_SIZE:0] syn_rptr,    //the synchronized signal after 2 DFF
    input      [ADDR_SIZE:0] rptr,    //read pointer
    input      w_clk, w_rstn //clk and rstn signal
    );
    
    reg [ADDR_SIZE:0] syn_rptr_int;
    
    always @(posedge w_clk) begin    //2 DFF process
        if (!w_rstn) begin
            syn_rptr_int <= 0;
            syn_rptr <= 0;
        end
        else begin
            syn_rptr_int <= rptr;
            syn_rptr <= rptr;
        end
    end
    
endmodule