`ifndef DEFINES
`include "defines.v"
`define DEFINES
`endif

// IF: Instruction Fetch
`include "npc.v"
`include "pc.v"
`include "imem.v"

// ID: Instruction Decode
`include "ctrl.v"
`include "regs.v"
`include "imm_gen.v"

// EX: Execute
`include "alu.v"

// MEM: Memory Access
`include "bus.v"
`include "ram.v"


module MU_CPU (
    input clk,
    input rst_n,

    output [1:0] tmp_value
);

    wire zero;
    wire [`BRANCH_WIDTH-1:0] branch;
    wire [`CPU_WIDTH-1:0] curr_pc;
    wire [`CPU_WIDTH-1:0] offset;
    wire [`CPU_WIDTH-1:0] set_pc;

    wire [`CPU_WIDTH-1:0] next_pc;
    wire [`CPU_WIDTH-1:0] pc4;

    npc npc(
        .zero(zero),
        .branch(branch),
        .curr_pc(curr_pc),
        .offset(offset),
        .set_pc(set_pc),
        
        .next_pc(next_pc),
        .pc4(pc4)
    );


    pc pc(
        .clk(clk),
        .rst_n(rst_n),
        .next_pc(next_pc),
        
        .curr_pc(curr_pc)
    );


    wire [`CPU_WIDTH-1:0] instruction;

    imem imem(
        .rst_n(rst_n),
        .curr_pc(curr_pc),

        .instruction(instruction)
    );


    wire [`ALU_OP_WIDTH-1:0] alu_op;
    wire [`ALU_SRC_WIDTH-1:0] alu_src;
    wire [`IMM_OP_WIDTH-1:0] imm_op;
    wire [`REG_WRITE_WIDTH-1:0] reg_write;
    wire [`MEM_SIZE_WIDTH-1:0] mem_size;

    wire mem_valid_ctrl;
    wire mem_we_ctrl;

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    ctrl ctrl(
        .instruction(instruction),

        .branch(branch),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .imm_op(imm_op),
        .reg_write(reg_write),
        .mem_size(mem_size),

        .mem_valid_ctrl(mem_valid_ctrl),
        .mem_we_ctrl(mem_we_ctrl),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd)
    );

    wire [`CPU_WIDTH-1:0] mem_in;
    wire [`CPU_WIDTH-1:0] alu_out;
    wire [`CPU_WIDTH-1:0] rs1_data;
    wire [`CPU_WIDTH-1:0] rs2_data;

    regs regs(
        .clk(clk),
        .rst_n(rst_n),
        .reg_write(reg_write),
        .mem_size(mem_size),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .pc4(pc4),
        .mem_in(mem_in),
        .alu_out(alu_out),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );


    wire [`CPU_WIDTH-1:0] immediate;

    imm_gen imm_gen(
        .instruction(instruction),
        .imm_op(imm_op),

        .immediate(immediate)
    );


    alu alu(
        .curr_pc(curr_pc),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .immediate(immediate),

        .alu_src(alu_src),
        .alu_op(alu_op),

        .zero(zero),
        .alu_out(alu_out)
    );


    assign offset = immediate;

    assign set_pc = rs1_data;


    wire [`CPU_WIDTH-1:0] addr_bus_mas;
    wire [`CPU_WIDTH-1:0] addr_bus_slv;
    wire we_ctrl_slv;
    wire [`CPU_WIDTH-1:0] data_bus_mas;
    wire [`CPU_WIDTH-1:0] data_bus_slv;
    wire valid_ctrl_ram;


    bus bus(
        .addr_bus_mas(addr_bus_mas),
        .addr_bus_slv(addr_bus_slv),
        .we_ctrl_mas(mem_we_ctrl),
        .we_ctrl_slv(we_ctrl_slv),
        .data_bus_mas(data_bus_mas),
        .data_bus_slv(data_bus_slv),
        .valid_ctrl_mas(mem_valid_ctrl),
        .valid_ctrl_slv1(valid_ctrl_ram)
    );
    
    ram ram(
        .clk(clk),
        .rst_n(rst_n),
        .valid_ctrl(valid_ctrl_ram),
        .we_ctrl(we_ctrl_slv),
        .addr(addr_bus_slv),
        .data(data_bus_slv)
    );

    assign addr_bus_mas = alu_out;
    assign mem_in = data_bus_mas;
    assign data_bus_mas = (mem_valid_ctrl && ~mem_we_ctrl) ? rs2_data : `CPU_WIDTH'bz;


    assign tmp_value = {regs.reg_unit[10][0], regs.reg_unit[11][0]};


endmodule