module wptr_full
    #(
    parameter ADDR_SIZE = 6
    )
    (
    output  reg wfull,
    output      [ADDR_SIZE-1:0] waddr, //bin    this signal is for RAM, no need to add one more digit indicate address
    output  reg [ADDR_SIZE:0] wptr, //gray      this signal is for pointer to judge, so need one more digit to judge if the RAM is empty or full
    input       [ADDR_SIZE:0] syn_rptr, //gray
    input       w_en, wclk, wrstn
    );
    
    reg  [ADDR_SIZE:0] wbin;
    wire [ADDR_SIZE:0] wgraynext, wbinnext;
    reg wfull_int;
    
    always @(posedge wclk or negedge wrstn) begin  // pointer process is pretty like FSM
        if (!wrstn) begin
            wbin <= 0;
            wptr <= 0;
        end
        else begin
            wbin <= wbinnext;
            wptr <= wgraynext;
        end
    end
    
    // Memory write address pointer (okay to use binary to address memory, Gray code used here to avoid metastability) 
    assign waddr = wbin[ADDR_SIZE-1:0];
    assign wbinnext = wbin + (w_en & ~ wfull);  //(w_en & ~ wfull) is 1 digit, means pointer + 1
    assign wgraynext = (wbinnext >> 1) ^ wbinnext;  // convert bin into gray code
    //wfull signal is based on gray code to avoid metastability
    always @(*) begin
        //full signal is 1 when first MSB and second is reversed, and other is the same
        if (wgraynext == {~syn_rptr[ADDR_SIZE:ADDR_SIZE-1], syn_rptr[ADDR_SIZE-3:0]}) begin
            wfull_int = 1'b1;
        end
        else begin
            wfull_int = 1'b0;
        end
    end
    
    always @(posedge wclk or negedge wrstn) begin  //wait one clock cycle to output full signal
        if (!wrstn) begin
            wfull  <= 1'b0;
        end
        else begin
            wfull  <= wfull_int;
        end
    end
    
endmodule
