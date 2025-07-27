module wr_ptr_handler #(parameter ADDR_LEN = 5)(
        input wr_clk, wr_rstn, wr_en,
        input [ADDR_LEN:0] sync_rd_ptr,
        output reg wr_full,
        output [ADDR_LEN-1:0] wr_addr,
        output reg [ADDR_LEN:0] wr_ptr
    );

    wire [ADDR_LEN:0] wr_bin_next, wr_gray_next;
    reg [ADDR_LEN:0] wr_bin;
    wire wr_full_val;

    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn)
            {wr_bin, wr_ptr} <= 0;
        else 
            {wr_bin, wr_ptr} <= {wr_bin_next, wr_gray_next};
    end

    assign wr_bin_next = wr_bin + (~wr_full & wr_en);
    assign wr_gray_next = (wr_bin_next >> 1) ^ wr_bin_next;

    assign wr_full_val = (wr_gray_next == { ~sync_rd_ptr[ADDR_LEN:ADDR_LEN-1], sync_rd_ptr[ADDR_LEN-2:0]});
    assign wr_addr = wr_bin[ADDR_LEN-1:0];


    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn)
            wr_full <= 1'b0;
        else
            wr_full <= wr_full_val;
    end

endmodule