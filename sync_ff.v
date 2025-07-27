module double_sync_ff #(parameter ADDR_LEN = 5)(
        input clk,rstn,
        input [ADDR_LEN:0] in,
        output reg [ADDR_LEN:0] out
    );

    reg [ADDR_LEN:0] out_prev;
    

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            out_prev <= 0;
            out <= 0;
        end 
        else begin
            out_prev <= in;
            out <= out_prev;
        end
    end
    
endmodule