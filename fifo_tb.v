`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/01 15:43:04
// Design Name: 
// Module Name: fifo_tb
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


module fifo_tb();

    reg  [31:0] w_data;
    reg         w_en, w_clk, w_rstn; 
    reg         r_en, r_clk, r_rstn;
    wire [31:0] r_data;  
    wire        full;  
    wire        empty;  

    fifo u_fifo (
        .r_data (r_data),  
        .full   (full),  
        .empty  (empty),  
        .w_data (w_data),  
        .w_en   (w_en), 
        .w_clk  (w_clk), 
        .w_rstn (w_rstn), 
        .r_en   (r_en), 
        .r_clk  (r_clk), 
        .r_rstn (r_rstn)
     );
     
    localparam CYCLE = 20;
    localparam CYCLE1 = 40;


    initial begin
        w_clk = 0;
        forever
        #(CYCLE/2)
        w_clk=~w_clk;
    end
    initial begin
        r_clk = 0;
        forever
        #(CYCLE1/2)
        r_clk=~r_clk;
    end
    
    initial begin
        w_rstn = 1;
        #2;
        w_rstn = 0;
        #(CYCLE*3);
        w_rstn = 1;
    end
    
     initial begin
        r_rstn = 1;
        #2;
        r_rstn = 0;
        #(CYCLE*3);
        r_rstn = 1;
    end
            
     initial begin
         w_en=0;
         #5 w_en=1;
     end 
    
     initial begin
        r_en=0;
         #5 r_en=1;
     end 

//   #5 rinc =1;
//             always  @(posedge wclk or negedge wrst_n)begin
//                 if(wrst_n==1'b0)begin
//                     winc <= 0;
//                     rinc <= 0;
//                 end
//                 else begin
//                     winc <= $random;
//                     rinc <= $random;
//                 end
//             end

//             always  @(posedge rclk or negedge rrst_n)begin
//                 if(rrst_n==1'b0)begin                  
//                     rinc <= 0;
//                 end
//                 else begin                
//                     rinc <= $random;
//                 end
//             end
// always@(*)begin
//   if(winc == 1)
//     wdata= $random ;
//   else
//     wdata = 0;
// end  

always #30 w_data= $random ;

endmodule