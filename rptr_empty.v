module rptr_empty //entity control the fifo read pointer and generates empty signal
#(
    parameter ADDR_SIZE = 6
)
(
    output reg  rempty, 
    output      [ADDR_SIZE-1:0] raddr, //bin
    output reg  [ADDR_SIZE:0] rptr, //gary
    input       [ADDR_SIZE:0] syn_wptr,
    input       r_en, rclk, rrstn
);
    reg  [ADDR_SIZE:0] rbin;
    wire [ADDR_SIZE:0] rbin_next,rgray_next;
    reg  rempty_int;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin <= 0;
            rptr <= 0;
        end
        else begin
            rbin <= rbin_next;
            rptr <= rgray_next;
        end
    end
    
    // Memory write address pointer (okay to use binary to address memory, Gray code used here to avoid metastability) 
    assign raddr = rbin;
    assign rbin_next = rbin + (r_en & ~ rempty);  //(w_en & ~ wfull) is 1 digit, means pointer + 1 when r_en and fifo is not empty
    assign rgray_next = (rbin_next >> 1) ^ rbin_next;  // convert bin into gray code
    // FIFO empty when the next rptr == synchronized wptr or on reset 
    always @(*) begin
        if (rgray_next == syn_wptr) begin
            rempty_int <= 1'b1;
        end
        else begin
            rempty_int <= 1'b0;
        end
    end
    //wait one clk
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1'b1;
        end
        else begin
            rempty <=rempty_int;
        end
    end
    
endmodule