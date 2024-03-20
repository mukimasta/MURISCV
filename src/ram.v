`ifndef DEFINES
`include "defines.v"
`define DEFINES
`endif

module ram (
    input clk,
    input rst_n,

    input valid_ctrl,
    input we_ctrl,
    input [`CPU_WIDTH-1:0] addr,

    inout [`CPU_WIDTH-1:0] data

);
    
    reg [`CPU_WIDTH-1:0] ram_unit [0:`RAM_DEPTH-1];

    wire [`CPU_WIDTH-1:0] data_in;

    assign data_in = data;
    assign data = (valid_ctrl && we_ctrl) ? ram_unit[addr[`CPU_WIDTH-1:2]] : `CPU_WIDTH'bz;

    integer i;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < `RAM_DEPTH; i = i + 1) begin
                ram_unit[i] <= `CPU_WIDTH'b0;
            end
        end else begin
            if (valid_ctrl && ~we_ctrl) begin
                ram_unit[addr[`CPU_WIDTH-1:2]] <= data_in;
            end
        end
    end

endmodule