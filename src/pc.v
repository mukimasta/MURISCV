`ifndef DEFINES
`include "defines.v"
`define DEFINES
`endif

module pc(
    input clk,
    input rst_n,
    input [`CPU_WIDTH-1:0] next_pc,

    output reg [`CPU_WIDTH-1:0] curr_pc // pc_out_current_address
);

    always@(posedge clk or negedge rst_n) begin //synchronic reset
        if(~rst_n) begin
            curr_pc <= -`CPU_WIDTH'h4;
        end
        else begin
            curr_pc <= next_pc;
        end
    end

endmodule