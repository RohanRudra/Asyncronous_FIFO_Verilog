module FIFO_memory #(parameter DATA_LEN = 8,
    parameter ADDR_LEN = 5)(
        input [DATA_LEN-1:0] wr_data,
        input [ADDR_LEN-1:0] wr_addr, rd_addr,
        input wr_en, wr_full, wr_clk, rd_clk,
        output [DATA_LEN-1:0] rd_data
    );

    localparam WIDTH = 1 << ADDR_LEN;
    
    reg [DATA_LEN-1:0] memory [0:WIDTH-1];

    //Write operation
    always @(posedge wr_clk) begin
        if(!wr_full && wr_en) begin
            memory[wr_addr] <= wr_data;
        end
    end

    //Read operation
    // always @(posedge rd_clk) begin
    //     rd_data <= memory[rd_addr];
    // end
    assign rd_data = memory[rd_addr];

endmodule