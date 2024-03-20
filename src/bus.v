`ifndef DEFINES
`include "defines.v"
`define DEFINES
`endif

module bus (

    // from Master
    input [`CPU_WIDTH-1:0] addr_bus_mas,
    output [`CPU_WIDTH-1:0] addr_bus_slv,

    input we_ctrl_mas,
    output we_ctrl_slv,

    inout [`CPU_WIDTH-1:0] data_bus_mas,
    inout [`CPU_WIDTH-1:0] data_bus_slv,

    input valid_ctrl_mas,

    // to Slave 1
    output valid_ctrl_slv1,
    // to Slave 2
    output valid_ctrl_slv2,
    // to Slave 3
    output valid_ctrl_slv3,
    // to Slave 4
    output valid_ctrl_slv4
    );
    
    assign addr_bus_slv = {{2{1'b0}}, addr_bus_mas[`CPU_WIDTH-3:0]}; // preserve 4 slaves select


    assign data_bus_slv = (~we_ctrl_mas) ? data_bus_mas : `CPU_WIDTH'bz;
    assign data_bus_mas = (we_ctrl_mas) ? data_bus_slv : `CPU_WIDTH'bz;

    assign we_ctrl_slv = we_ctrl_mas;


    wire [1:0] slv_sel;
    assign slv_sel = addr_bus_mas[`CPU_WIDTH-1:(`CPU_WIDTH-2)];

    assign valid_ctrl_slv1 = (slv_sel == 2'b00) ? valid_ctrl_mas : 1'b0;
    assign valid_ctrl_slv2 = (slv_sel == 2'b01) ? valid_ctrl_mas : 1'b0;
    assign valid_ctrl_slv3 = (slv_sel == 2'b10) ? valid_ctrl_mas : 1'b0;
    assign valid_ctrl_slv4 = (slv_sel == 2'b11) ? valid_ctrl_mas : 1'b0;

endmodule