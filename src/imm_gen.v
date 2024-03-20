`ifndef DEFINES
`include "defines.v"
`define DEFINES
`endif

module imm_gen(
    input [`CPU_WIDTH-1:0] instruction,
    input [`IMM_OP_WIDTH-1:0] imm_op,

    output reg [`CPU_WIDTH-1:0] immediate
);

    always @(*) begin
        case (imm_op)
            // `TYPE_R: pass
            `IMM_OP_I: immediate = {{20{instruction[31]}}, instruction[31:20]};
            `IMM_OP_S: immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            `IMM_OP_B: immediate = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            `IMM_OP_U: immediate = {instruction[31:12], 12'b0};
            `IMM_OP_J: immediate = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            default: immediate = `CPU_WIDTH'b0;
        endcase
    end



endmodule