`ifndef DEFINES
`include "defines.v"
`define DEFINES
`endif

module alu(
    input [`CPU_WIDTH-1:0] curr_pc,
    input [`CPU_WIDTH-1:0] rs1_data,
    input [`CPU_WIDTH-1:0] rs2_data,
    input [`CPU_WIDTH-1:0] immediate,

    input [`ALU_SRC_WIDTH-1:0] alu_src,
    input [`ALU_OP_WIDTH-1:0] alu_op,

    output zero,
    output reg [`CPU_WIDTH-1:0] alu_out
);

    /***** ALU MUX *****/

    reg [`CPU_WIDTH-1:0] alu_in1;
    reg [`CPU_WIDTH-1:0] alu_in2;

    always @(*) begin
        case (alu_src)
            `ALU_SRC_REG: begin
                alu_in1 = rs1_data;
                alu_in2 = rs2_data;
            end

            `ALU_SRC_IMM: begin
                alu_in1 = rs1_data;
                alu_in2 = immediate;
            end

            `ALU_SRC_AUIPC: begin
                alu_in1 = curr_pc;
                alu_in2 = immediate;
            end

            default: begin
                alu_in1 = `CPU_WIDTH'bz;
                alu_in2 = `CPU_WIDTH'bz;
            end
        endcase
    end


    /***** ALU *****/

    always@(*) begin
        case (alu_op)
            `ALU_ADD: alu_out = alu_in1 + alu_in2;
            `ALU_SUB: alu_out = alu_in1 - alu_in2;
            `ALU_SLL: alu_out = alu_in1 << alu_in2[4:0];
            `ALU_SLT: alu_out = ($signed(alu_in1) < $signed(alu_in2));
            `ALU_SLTU:alu_out = (alu_in1 < alu_in2);
            `ALU_XOR: alu_out = alu_in1 ^ alu_in2;
            `ALU_SRL: alu_out = alu_in1 >> alu_in2[4:0];
            `ALU_SRA: alu_out = $signed(alu_in1) >>> alu_in2[4:0];
            `ALU_OR:  alu_out = alu_in1 | alu_in2;
            `ALU_AND: alu_out = alu_in1 & alu_in2;

            `ALU_IN2: alu_out = alu_in2; // also for ALU_NONE
            
            default: alu_out = `CPU_WIDTH'b0;
        endcase
    end

    assign zero = (alu_out == `CPU_WIDTH'b0) ? 1 : 0; // iff alu_out is all 0s, zero is 1'b1


endmodule