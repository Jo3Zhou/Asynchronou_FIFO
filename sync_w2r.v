module sync_w2r //synchronizer - 2 DFF to synchronize the signal from write to read
    #(
    parameter ADDR_SIZE = 6
    )
    (
    output reg [ADDR_SIZE:0] syn_wptr,    //the synchronized signal after 2 DFF
    input      [ADDR_SIZE:0] wptr,    //wead pointer
    input      r_clk, r_rstn //clk and rstn signal
    );
    
    reg [ADDR_SIZE:0] syn_wptr_int;
    
    always @(posedge r_clk) begin    //2 D-FF
        if(!r_rstn) begin
            syn_wptr <= 1'b0;
            syn_wptr_int <= 1'b0;
        end
        else begin
            syn_wptr_int <= wptr;
            syn_wptr <= syn_wptr_int;
        end
    end
            
endmodule
