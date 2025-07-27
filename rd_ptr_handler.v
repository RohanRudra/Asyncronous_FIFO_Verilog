module rd_ptr_handler #(parameter ADDR_LEN = 5)(
        input rd_en, rd_clk, rd_rstn,
        input [ADDR_LEN:0] sync_wr_ptr,
        output reg rd_empty,
        output [ADDR_LEN-1:0] rd_addr,
        output reg [ADDR_LEN:0] rd_ptr
    );

    wire [ADDR_LEN:0] rd_bin_next, rd_gray_next;
    reg [ADDR_LEN:0] rd_bin;
    wire rd_empty_val;

    always @(posedge rd_clk or negedge rd_rstn) begin
        if (!rd_rstn)
            {rd_bin, rd_ptr} <= 0;
        else
            {rd_bin, rd_ptr} <= {rd_bin_next, rd_gray_next};
    end

    assign rd_bin_next = rd_bin + (~rd_empty & rd_en);
    assign rd_gray_next = (rd_bin_next >> 1) ^ rd_bin_next;

    assign rd_empty_val = (rd_gray_next == sync_wr_ptr);
    assign rd_addr = rd_bin[ADDR_LEN-1:0];


    always @(posedge rd_clk or negedge rd_rstn) begin
        if (!rd_rstn)
            rd_empty <= 1'b1;
        else
            rd_empty <= rd_empty_val;
    end

endmodule