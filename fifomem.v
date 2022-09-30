module fifomem  //fifo mem
    #(
    parameter DATA_SIZE = 32,
    parameter ADDR_SIZE = 6
    )
    (
    output [DATA_SIZE-1:0] rdata,
    input [DATA_SIZE-1:0] wdata,
    
    input [ADDR_SIZE-1:0] waddr,
    input [ADDR_SIZE-1:0] raddr,
    
    input wclken,
    input wfull,
    input wclk
    );
    
    localparam DEPTH = 1 << ADDR_SIZE;  //depth = 2 ^ (ADDR_SIZE) = 64, localpara here is to avoid DEPTH changed by other parents entity
    reg [DATA_SIZE-1:0] mem [0:DEPTH-1];    //first parameter is width in mem, second is depth of mem
    assign rdata = mem[raddr];
    
    always @(posedge wclk) begin
        if (wclken && !wfull) begin //when mem is not full and wclken is 1, then output wdata from mem
            mem[waddr] <= wdata;
        end
    end

    
    
endmodule
