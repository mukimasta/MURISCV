`ifndef DEFINES
`include "defines.v"
`define DEFINES
`endif

module regs(
    input clk,
    input rst_n,
    input [`REG_WRITE_WIDTH-1:0] reg_write,
    input [`MEM_SIZE_WIDTH-1:0] mem_size,

    // address for registers
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,

    input [`CPU_WIDTH-1:0] pc4,
    input [`CPU_WIDTH-1:0] mem_in,
    input [`CPU_WIDTH-1:0] alu_out,

    output [`CPU_WIDTH-1:0] rs1_data,
    output [`CPU_WIDTH-1:0] rs2_data
);

    reg [`CPU_WIDTH-1:0] reg_unit [1:`REG_DEPTH-1];


    /***** REG MUX *****/

    wire [`CPU_WIDTH-1:0] rd_word;
    assign rd_word = (reg_write == `REG_WRITE_ALU) ? alu_out
                     : (reg_write == `REG_WRITE_PC4) ? pc4
                     : (reg_write == `REG_WRITE_MEM) ? mem_in
                     : `CPU_WIDTH'bz;

    wire [`CPU_WIDTH-1:0] rd_byte = {{24{rd_word[7]}}  ,rd_word[7:0]};
    wire [`CPU_WIDTH-1:0] rd_byte_u = {{24{1'b0}}      ,rd_word[7:0]};
    wire [`CPU_WIDTH-1:0] rd_half = {{16{rd_word[15]}},rd_word[15:0]};
    wire [`CPU_WIDTH-1:0] rd_half_u = {{16{1'b0}}     ,rd_word[15:0]};

    wire [`CPU_WIDTH-1:0] rd_data = (mem_size == `MEM_BYTE) ? rd_byte
                                    : (mem_size == `MEM_HALF) ? rd_half
                                    : (mem_size == `MEM_BYTE_U) ? rd_byte_u
                                    : (mem_size == `MEM_HALF_U) ? rd_half_u
                                    : rd_word;


    // write data
    always@(posedge clk) begin
        if(rst_n     &&
           reg_write!=`REG_WRITE_DISABLE &&
           (rd != 0) )  // x0 is always 0 in RISC-V
        begin
            reg_unit[rd] <= rd_data;
        end
    end

    wire [`CPU_WIDTH-1:0] rs2_word;

    // read data
    assign rs1_data = (rs1==5'b0) ? 0 : reg_unit[rs1]; // x0 is always 0 in RISC-V
    assign rs2_word = (rs2==5'b0) ? 0 : reg_unit[rs2]; // x0 is always 0 in RISC-V

    wire [`CPU_WIDTH-1:0] rs2_byte = {{24{rs2_word[7]}}  ,rs2_word[7:0]};
    wire [`CPU_WIDTH-1:0] rs2_half = {{16{rs2_word[15]}},rs2_word[15:0]};
    
    assign rs2_data = (mem_size == `MEM_BYTE) ? rs2_byte
                     : (mem_size == `MEM_HALF) ? rs2_half
                     : rs2_word;

    // // tmp
    // assign tmp_x10_value = reg_unit[10];
    // assign tmp_x11_value = reg_unit[11];

endmodule