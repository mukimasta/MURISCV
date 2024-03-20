`ifndef DEFINES
`include "defines.v"
`define DEFINES
`endif

module imem(
    input rst_n,
    input [`CPU_WIDTH-1:0] curr_pc,
    
    output [`CPU_WIDTH-1:0] instruction
);


    reg [`CPU_WIDTH-1:0] inst_mem_unit [0:`IMEM_DEPTH-1];
    
    assign instruction = (`IMEM_DEPTH == -`CPU_WIDTH'h4) ? 32'bz
                       : inst_mem_unit[curr_pc[`CPU_WIDTH-1:2]]; // address by byte / byte addressable, 2: ADDRESS_BITS_OVERLOOKED


    always @(*) begin
        if(~rst_n) begin
            $readmemh("instructions.txt", inst_mem_unit);
        end
    end
endmodule



//************** first test program ******************

// nop
// li x9 6
// li x10 0
// li x8 0
// begin:
// addi x11 x10 1
// mv x10 x11
// beq x10 x9 out
// beq x8 x0 begin
// out:
// nop

// 0x00000013
// 0x00600493
// 0x00000513
// 0x00000413
// 0x00150593
// 0x00058513
// 0x00950463
// 0xFE040AE3
// 0x00000013


// ****************** shift test program ******************

// li x0 3
// mv x10 x0
// multwo:
// li x10 1
// slli x10 x10 3
// li x11 0xff
// slli x11 x11 24
// srai x11 x11 8
// srli x11 x11 8


// 0x00300013
// 0x00000513
// 0x00100513
// 0x00351513
// 0x0FF00593
// 0x01859593
// 0x4085D593
// 0x0085D593



// ****************** jal test program ******************

// li x10 0
// li x11 0
// li x9 3
// begin:
// addi x10 x10 1
// bge x10 x9 end
// j begin
// end:
// addi x11 x11 1
// bltu x9 x11 if
// li x10 0
// jal x12 begin
// if:
// li x9 40
// beq x9 x12 correct
// wrong:
// li x10 1
// j final
// correct:
// li x10 0
// final:
// nop

// 0x00000513
// 0x00000593
// 0x00300493
// 0x00150513
// 0x00955463
// 0xFF9FF06F
// 0x00158593
// 0x00B4E663
// 0x00000513
// 0xFE9FF66F
// 0x02800493
// 0x00C48663
// 0x00100513
// 0x0080006F
// 0x00000513
// 0x00000013
