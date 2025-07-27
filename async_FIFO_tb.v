`include "main_FIFO.v"
`timescale 1ns/1ps

module top_tb();

    parameter DATA_LEN = 8;
    parameter ADDR_LEN = 3;
    parameter DEPTH = 1 << ADDR_LEN;

    reg wr_clk, rd_clk, wr_rstn, rd_rstn, wr_en, rd_en;
    reg [DATA_LEN-1:0] wr_data;
    wire [DATA_LEN-1:0] rd_data;
    wire wr_full, rd_empty;

    FIFO #(DATA_LEN, ADDR_LEN) FIFO(
        .wr_clk(wr_clk), .rd_clk(rd_clk), .wr_rstn(wr_rstn), .rd_rstn(rd_rstn), .wr_en(wr_en), .rd_en(rd_en), 
        .wr_data(wr_data),
        .wr_full(wr_full), .rd_empty(rd_empty),
        .rd_data(rd_data)
    );

    always #5 wr_clk = ~wr_clk;
    always #10 rd_clk = ~rd_clk;

    integer i = 0;
    integer seed = 1;

    initial begin
        wr_clk = 0;
        rd_clk = 0; 
        wr_rstn = 1; 
        rd_rstn = 1; 
        wr_en = 0; 
        rd_en = 0;
        wr_data = 0;


        #40 wr_rstn = 0; rd_rstn = 0;
        #40 wr_rstn = 1; rd_rstn = 1;


        //Test1 - Write & Read
        rd_en = 1;
        for (i = 0; i < 10; i = i + 1) begin
            wr_data = $random(seed) % 256;

            wr_en = 1;
            #10;
            wr_en = 0;
            #10;
        end


        //Test2 - Write & full it & try writing more
        rd_en = 0;
        wr_en = 1;
        for (i = 0; i < DEPTH + 4; i = i + 1) begin
            wr_data = $random(seed) % 256;
            #10;
        end


        //Test3 - Read data & empty FIFO & try reading more
        wr_en = 0;
        rd_en = 1;
        for (i = 0; i < DEPTH + 3; i = i + 1) begin
            #20;
        end

        $finish;

    end
endmodule