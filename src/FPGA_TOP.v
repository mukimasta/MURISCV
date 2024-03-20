`include "MU_CPU.v"
`include "clk_div.v"

module FPGA_TOP (
    input clk,
    input rst_n,

    output clk_sys_n,

    output [1:0] tmp_value_n
);

    wire clk_sys;
    wire [1:0] tmp_value;

    clk_div clk_div(
        .clk(clk),
        .rst_n(rst_n),

        .clk_sys(clk_sys)
    );

    MU_CPU MU_CPU(
        .clk(clk_sys),
        .rst_n(rst_n),

        .tmp_value(tmp_value)
    );

    assign clk_sys_n = ~clk_sys;
    assign tmp_value_n = ~tmp_value;

endmodule