`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jialu
// 
// Create Date: 2022/09/30 14:05:23
// Design Name: 
// Module Name: fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module fifo
    #(
    parameter DATA_SIZE = 32,
    parameter ADDR_SIZE = 6
    )
    (
    input w_clk, r_clk,
    input w_en, r_en,
    input w_rstn, r_rstn,
    output [DATA_SIZE-1:0] r_data,
    input [DATA_SIZE-1:0] w_data,
    output full, empty
    );
    
    wire [ADDR_SIZE:0]      syn_rptr,syn_wptr;
    wire [ADDR_SIZE:0]      rptr,wptr;
    wire [ADDR_SIZE-1:0]    raddr,waddr;
    
    // synchronize the read pointer into the write-clock domain
    sync_r2w  sync_r2w
    ( 
    .syn_rptr    (syn_rptr),
    .rptr        (rptr),                          
    .w_clk       (w_clk), 
    .w_rstn      (w_rstn)  
    );

    sync_w2r  sync_w2r
    ( 
    .syn_wptr    (syn_wptr),
    .wptr        (wptr),                          
    .r_clk       (r_clk), 
    .r_rstn      (r_rstn)  
    );   
    
    //this is the FIFO memory buffer that is accessed by both the write and read clock domains.
    fifomem 
    #(DATA_SIZE, ADDR_SIZE)
    fifomem                        
    (
    .rdata    (r_data), 
    .wdata    (w_data),                           
    .waddr    (waddr),
    .raddr    (raddr),                           
    .wclken   (w_en),
    .wfull    (full),                           
    .wclk (w_clk)
    );
    
    //this module is completely synchronous to the read-clock domain and contains the FIFO read pointer and empty-flag logic.  
    rptr_empty
    #(ADDR_SIZE)    
    rptr_empty                          
    (
    .rempty     (empty),                          
    .raddr      (raddr),                          
    .rptr       (rptr),
    .syn_wptr   (syn_wptr),                          
    .r_en       (r_en),
    .rclk       (r_clk),                          
    .rrstn      (r_rstn)
    );
    
    //this module is completely synchronous to the write-clock domain and contains the FIFO write pointer and full-flag logic
    wptr_full 
    #(ADDR_SIZE)    
    wptr_full                         
    (
    .wfull     (full),
    .waddr      (waddr),  
    .wptr       (wptr),
    .syn_rptr   (syn_rptr),    
    .w_en       (w_en),
    .wclk      (w_clk),        
    .wrstn     (w_rstn)
    );    
    
endmodule
