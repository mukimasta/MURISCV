`ifndef DEFINES
`include "defines.v"
`define DEFINES
`endif

module npc (
    input zero,
    input [`BRANCH_WIDTH-1:0] branch,
    input [`CPU_WIDTH-1:0] curr_pc,
    input [`CPU_WIDTH-1:0] offset,
    input [`CPU_WIDTH-1:0] set_pc,

    output reg [`CPU_WIDTH-1:0] next_pc,
    output [`CPU_WIDTH-1:0] pc4 // curr_pc + 4

);
    
    assign pc4 = curr_pc + `CPU_WIDTH'h4;
    
    always @(*) begin
        case (branch)
            `BRANCH_DISABLE: next_pc = pc4;
            `BRANCH_ZERO: next_pc = (zero) ? curr_pc + offset : pc4;
            `BRANCH_NOT_ZERO: next_pc = (zero) ? pc4 : curr_pc + offset;
            `BRANCH_JAL: next_pc = curr_pc + offset;
            `BRANCH_JALR: next_pc = set_pc + offset;
            default: next_pc = pc4;
        endcase
    end



endmodule