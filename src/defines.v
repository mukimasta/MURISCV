
/***** CPU BIT WIDTH *****/

`define CPU_WIDTH 32
// `define ADDRESS_BITS_OVERLOOKED 2 // address by byte / byte addressable (32/8=2^2) (RV32)

`define IMEM_DEPTH 1024
// `define PC_WIDTH 32 // = `CPU_WIDTH // actual: 12 // 2^(12-2) = 1024 (use 12 bits to address 1024 bytes)



/***** REGISTERS *****/
`define REG_DEPTH 32 // 32 registers in RISC-V

/***** RAM *****/
`define RAM_DEPTH 1024 // 1024 bytes of RAM (1KB)


/***** INSTRUCTIONS MATCH *****/
// opcode
`define OPCODE_R 7'b0110011
`define OPCODE_I 7'b0010011
`define OPCODE_I_LD 7'b0000011
`define OPCODE_S 7'b0100011
`define OPCODE_B 7'b1100011
`define OPCODE_LUI 7'b0110111
`define OPCODE_AUIPC 7'b0010111
`define OPCODE_JAL 7'b1101111
`define OPCODE_JALR 7'b1100111



/***** CONTROL SIGNALS *****/

// branch
`define BRANCH_WIDTH 3
`define BRANCH_DISABLE 3'b000
`define BRANCH_ZERO 3'b001
`define BRANCH_NOT_ZERO 3'b010
`define BRANCH_JAL 3'b011
`define BRANCH_JALR 3'b100

// alu_op (alu_operation_code)
`define ALU_OP_WIDTH 4
`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001
`define ALU_SLL 4'b0010
`define ALU_SLT 4'b0011
`define ALU_SLTU 4'b0100
`define ALU_XOR 4'b0101
`define ALU_SRL 4'b0110
`define ALU_SRA 4'b0111
`define ALU_OR 4'b1000
`define ALU_AND 4'b1001

`define ALU_IN2 4'b1101
`define ALU_NONE 4'b1101

// alu source
`define ALU_SRC_WIDTH 2
`define ALU_SRC_REG 2'b00
`define ALU_SRC_IMM 2'b01
`define ALU_SRC_AUIPC 2'b10

`define ALU_SRC_NONE 2'b10

// instruction type code --> imm_gen_op
`define IMM_OP_WIDTH 3
`define IMM_OP_R 3'b000
`define IMM_OP_I 3'b001
`define IMM_OP_S 3'b010
`define IMM_OP_B 3'b011
`define IMM_OP_U 3'b100
`define IMM_OP_J 3'b101

// reg_write
`define REG_WRITE_WIDTH 2
`define REG_WRITE_DISABLE 2'b00
`define REG_WRITE_ALU 2'b10
`define REG_WRITE_PC4 2'b01
`define REG_WRITE_MEM 2'b11

// mem_bytes_size_ctrl
`define MEM_SIZE_WIDTH 3
`define MEM_BYTE 3'b000
`define MEM_BYTE_U 3'b100
`define MEM_HALF 3'b001
`define MEM_HALF_U 3'b101
`define MEM_WORD 3'b010
