`include "FIFO_Memory.v"
`include "sync_ff.v"
`include "wr_ptr_handler.v"
`include "rd_ptr_handler.v"

module FIFO #(parameter DATA_LEN = 8,
    parameter ADDR_LEN = 5)(
        input wr_clk, rd_clk, wr_rstn, rd_rstn, wr_en, rd_en,
        input [DATA_LEN-1:0] wr_data,
        output wr_full, rd_empty,
        output [DATA_LEN-1:0] rd_data
    );

    wire [ADDR_LEN-1:0] wr_addr, rd_addr;
    wire [ADDR_LEN:0] wr_ptr_g, rd_ptr_g, wr_ptr_syncr, rd_ptr_syncw;

    FIFO_memory #(DATA_LEN, ADDR_LEN) FIFO_Memory(
        .wr_data(wr_data),
        .wr_addr(wr_addr), .rd_addr(rd_addr),
        .wr_en(wr_en), .wr_full(wr_full), .wr_clk(wr_clk), .rd_clk(rd_clk),
        .rd_data(rd_data)
    );

    double_sync_ff #(ADDR_LEN) sync_ff_wr(
        .clk(wr_clk), .rstn(wr_rstn),
        .in(rd_ptr_g),
        .out(rd_ptr_syncw)
    );

    double_sync_ff #(ADDR_LEN) sync_ff_RD(
        .clk(rd_clk), .rstn(rd_rstn),
        .in(wr_ptr_g),
        .out(wr_ptr_syncr)
    );

    wr_ptr_handler #(ADDR_LEN) wr_ptr_handler(
        .wr_clk(wr_clk), .wr_rstn(wr_rstn), .wr_en(wr_en),
        .sync_rd_ptr(rd_ptr_syncw),
        .wr_full(wr_full),
        .wr_addr(wr_addr),
        .wr_ptr(wr_ptr_g)
    );

    rd_ptr_handler #(ADDR_LEN) rd_ptr_handler(
        .rd_en(rd_en), .rd_clk(rd_clk), .rd_rstn(rd_rstn),
        .sync_wr_ptr(wr_ptr_syncr),
        .rd_empty(rd_empty),
        .rd_addr(rd_addr),
        .rd_ptr(rd_ptr_g)
    );
    
endmodule