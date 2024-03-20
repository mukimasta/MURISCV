`timescale 1ps/1ps

`include "MU_CPU.v"


module tb ();
    
/* iverilog */
    initial begin
        $dumpfile("wave_cpu.vcd");
        $dumpvars(0, tb);
    end

    reg clk;
    reg rst_n;


    initial begin
        clk = 1'b1;
        rst_n = 1'b1;
        #50 rst_n = 1'b0;
        #50 rst_n = 1'b1;
    end

    initial begin
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        #10000 $finish;
    end

/* MU_CPU */
    wire [1:0] tmp_value;

    MU_CPU MU_CPU(
        .clk(clk),
        .rst_n(rst_n),

        .tmp_value(tmp_value)
    );

    wire [`CPU_WIDTH-1:0] tb_s10 = MU_CPU.regs.reg_unit[26];
    wire [`CPU_WIDTH-1:0] tb_s11 = MU_CPU.regs.reg_unit[27];


    wire [`CPU_WIDTH-1:0] tb_t2 = MU_CPU.regs.reg_unit[7];
    wire [`CPU_WIDTH-1:0] tb_t3 = MU_CPU.regs.reg_unit[28];

    wire [`CPU_WIDTH-1:0] tb_x10 = MU_CPU.regs.reg_unit[10];
    wire [`CPU_WIDTH-1:0] tb_x11 = MU_CPU.regs.reg_unit[11];

endmodule