`ifndef DEFINES
`include "defines.v"
`define DEFINES
`endif

module ctrl(
    input [`CPU_WIDTH-1:0] instruction,

    // control signals
    output reg [`BRANCH_WIDTH-1:0] branch,
    output reg [`ALU_OP_WIDTH-1:0] alu_op,
    output reg [`ALU_SRC_WIDTH-1:0] alu_src,
    output reg [`IMM_OP_WIDTH-1:0] imm_op,
    output reg [`REG_WRITE_WIDTH-1:0] reg_write,
    output reg [`MEM_SIZE_WIDTH-1:0] mem_size,

    output reg mem_valid_ctrl,
    output reg mem_we_ctrl,


    // paras into regs
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd

);

    // decode data DECODER
    wire [6:0] opcode = instruction[6:0];
    assign     rd = instruction[11:7];
    wire [2:0] funct3 = instruction[14:12];
    assign     rs1 = instruction[19:15];
    assign     rs2 = instruction[24:20];
    wire [6:0] funct7 = instruction[31:25];


    always @(*) begin
        case (opcode)

            `OPCODE_R: begin
                branch = `BRANCH_DISABLE;
                alu_src = `ALU_SRC_REG;
                imm_op = `IMM_OP_R;
                reg_write = `REG_WRITE_ALU;

                mem_valid_ctrl = 1'b0;
                mem_we_ctrl = 1'b1;
                mem_size = `MEM_WORD;

                case (funct3)
                    3'b000: begin
                        case (funct7)
                            7'b0000000: alu_op = `ALU_ADD; // add
                            7'b0100000: alu_op = `ALU_SUB; // sub
                            default: alu_op = `ALU_ADD;
                        endcase
                    end

                    3'b001: alu_op = `ALU_SLL; // sll
                    3'b010: alu_op = `ALU_SLT; // slt
                    3'b011: alu_op = `ALU_SLTU; // sltu
                    3'b100: alu_op = `ALU_XOR; // xor

                    3'b101: begin
                        case (funct7)
                            7'b0000000: alu_op = `ALU_SRL; // srl
                            7'b0100000: alu_op = `ALU_SRA; // sra
                            default: alu_op = `ALU_SRL;
                        endcase
                    end

                    3'b110: alu_op = `ALU_OR; // or
                    3'b111: alu_op = `ALU_AND; // and
                    
                    default: alu_op = `ALU_ADD;
                endcase
            end


            `OPCODE_I: begin
                branch = `BRANCH_DISABLE;
                alu_src = `ALU_SRC_IMM;
                imm_op = `IMM_OP_I;
                reg_write = `REG_WRITE_ALU;

                mem_valid_ctrl = 1'b0;
                mem_we_ctrl = 1'b1;
                mem_size = `MEM_WORD;

                case (funct3)
                    // arithmetic or set
                    3'b000: alu_op = `ALU_ADD; // addi
                    3'b010: alu_op = `ALU_SLT; // slti
                    3'b011: alu_op = `ALU_SLTU; // sltiu
                    3'b100: alu_op = `ALU_XOR; // xori
                    3'b110: alu_op = `ALU_OR; // ori
                    3'b111: alu_op = `ALU_AND; // andi
                    
                    // shift
                    3'b001: alu_op = `ALU_SLL; // slli
                    3'b101: begin
                        case (funct7)
                            7'b0000000: alu_op = `ALU_SRL; // srli
                            7'b0100000: alu_op = `ALU_SRA; // srai
                            default: alu_op = `ALU_SRL;
                        endcase
                    end

                    default: alu_op = `ALU_ADD;
                endcase
            end

            `OPCODE_I_LD: begin
                
                branch = `BRANCH_DISABLE;
                alu_src = `ALU_SRC_IMM;
                imm_op = `IMM_OP_I;
                alu_op = `ALU_ADD;
                reg_write = `REG_WRITE_MEM;
                mem_valid_ctrl = 1'b1;
                mem_we_ctrl = 1'b1;

                case (funct3)
                    3'b000: mem_size = `MEM_BYTE; // lb
                    3'b001: mem_size = `MEM_HALF; // lh
                    3'b010: mem_size = `MEM_WORD; // lw
                    3'b100: mem_size = `MEM_BYTE_U; // lbu
                    3'b101: mem_size = `MEM_HALF_U; // lhu
                    default: mem_size = `MEM_WORD;
                endcase

            end


            `OPCODE_S: begin
                
                branch = `BRANCH_DISABLE;
                alu_src = `ALU_SRC_IMM;
                imm_op = `IMM_OP_S;
                alu_op = `ALU_ADD;
                reg_write = `REG_WRITE_DISABLE;
                mem_valid_ctrl = 1'b1;
                mem_we_ctrl = 1'b0;

                case (funct3)
                    3'b000: mem_size = `MEM_BYTE; // sb
                    3'b001: mem_size = `MEM_HALF; // sh
                    3'b010: mem_size = `MEM_WORD; // sw
                    default: mem_size = `MEM_WORD;
                endcase

            end
            
            `OPCODE_B: begin

                // branch = case(funct3)
                alu_src = `ALU_SRC_REG;
                imm_op = `IMM_OP_B;
                reg_write = `REG_WRITE_DISABLE;

                mem_valid_ctrl = 1'b0;
                mem_we_ctrl = 1'b1;
                mem_size = `MEM_WORD;

                case (funct3)

                    3'b000: begin // beq
                        alu_op = `ALU_XOR; 
                        branch = `BRANCH_ZERO;
                    end

                    3'b001: begin // bne
                        alu_op = `ALU_XOR;
                        branch = `BRANCH_NOT_ZERO;
                    end

                    3'b100: begin // blt
                        alu_op = `ALU_SLT;
                        branch = `BRANCH_NOT_ZERO;
                    end

                    3'b101: begin // bge
                        alu_op = `ALU_SLT;
                        branch = `BRANCH_ZERO;
                    end

                    3'b110: begin // bltu
                        alu_op = `ALU_SLTU;
                        branch = `BRANCH_NOT_ZERO;
                    end

                    3'b111: begin // bgeu
                        alu_op = `ALU_SLTU; 
                        branch = `BRANCH_ZERO;
                    end

                    default: begin
                        alu_op = `ALU_XOR; 
                        branch = `BRANCH_ZERO;
                    end
                endcase
            end
            
            
            `OPCODE_LUI: begin
                branch = `BRANCH_DISABLE;
                alu_op = `ALU_IN2;
                alu_src = `ALU_SRC_IMM;
                imm_op = `IMM_OP_U;
                reg_write = `REG_WRITE_ALU;
                mem_valid_ctrl = 1'b0;
                mem_we_ctrl = 1'b1;
                mem_size = `MEM_WORD;
            end


            `OPCODE_AUIPC: begin
                branch = `BRANCH_DISABLE;
                alu_op = `ALU_ADD;
                alu_src = `ALU_SRC_AUIPC;
                imm_op = `IMM_OP_U;
                reg_write = `REG_WRITE_ALU;
                mem_valid_ctrl = 1'b0;
                mem_we_ctrl = 1'b1;
                mem_size = `MEM_WORD;
            end


            `OPCODE_JAL: begin
                branch = `BRANCH_JAL;
                alu_op = `ALU_NONE;        // alu is not used here
                alu_src = `ALU_SRC_NONE;   // alu is not used here
                imm_op = `IMM_OP_J;
                reg_write = `REG_WRITE_PC4;
                mem_valid_ctrl = 1'b0;
                mem_we_ctrl = 1'b1;
                mem_size = `MEM_WORD;
            end

            `OPCODE_JALR: begin
                branch = `BRANCH_JALR;
                alu_op = `ALU_NONE;        // alu is not used here
                alu_src = `ALU_SRC_NONE;  // alu is not used here
                imm_op = `IMM_OP_I;
                reg_write = `REG_WRITE_PC4;
                mem_valid_ctrl = 1'b0;
                mem_we_ctrl = 1'b1;
                mem_size = `MEM_WORD;
            end


            default: begin
                branch = `BRANCH_DISABLE;
                alu_op = `ALU_NONE;
                alu_src = `ALU_SRC_NONE;
                imm_op = `IMM_OP_I;
                reg_write = `REG_WRITE_DISABLE;
                mem_valid_ctrl = 1'b0;
                mem_we_ctrl = 1'b1;
                mem_size = `MEM_WORD;
            end
        endcase

        
    
    end
    



endmodule