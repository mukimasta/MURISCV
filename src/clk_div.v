module clk_div (
    input clk,
    input rst_n,

    output reg clk_sys // 10Hz
);
        
        reg [31:0] clk_sys_cnt;
        always @(posedge clk or negedge rst_n) begin
            if(~rst_n) begin
                clk_sys <= 1'b0;
                clk_sys_cnt <= 32'd0;
            end
            // cnt = 25 when simulating
            else if (clk_sys_cnt >= 32'd4_999_9) begin // 2.5Hz // (2.5e6) // 50MHz --> 20ns // 10Hz --> 0.1s = 2.5e6 * 20ns * 2
                clk_sys <= ~clk_sys;
                clk_sys_cnt <= 32'd0;
            end
            else begin
                clk_sys <= clk_sys;
                clk_sys_cnt <= clk_sys_cnt + 32'd1;
            end
        end
    
endmodule