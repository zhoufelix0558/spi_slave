/*
 * Copyright (c) 2024 Felix Zhou
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_felixzhou_spi_slave_ctrl (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  //assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

// ----------------- ios -------------------------------------- //
wire 	spi_ncs;
wire 	spi_clk;
wire 	spi_mosi;

wire 	spi_miso;
wire    fifo_out_dat_serial;

assign 	spi_ncs	=	ui_in[0];
assign  spi_clk =   ui_in[1];
assign  spi_mosi=   ui_in[2];


assign uo_out[7:0] = {6'd0,spi_miso,fifo_out_dat_serial};
    
// ----------------- variables -------------------------------- //
wire reg_wr_en;
wire[7:0]	reg_datin;
wire[7:0]   reg_addr;
wire[7:0]	reg_out;


wire        fifo_trans_dat_rdout_req;
wire[7:0]   fifo_trans_dat_rdout;

wire[7:0]   fifo_trans_to_SDK_dat;
wire        fifo_trans_to_SDK_dval;
//wire        fifo_trans_to_SDK_fval;



  
// ----------------- spi slave ctrl -------------------------- //

spi_slave_ctrl spi_slave_ctrl_inst (
    .sys_clk(clk), 
    .rst_n(rst_n), 
    .st_spi_ncs(spi_ncs), 
    .st_spi_clk(spi_clk), 
    .st_spi_mosi(spi_mosi), 
    .st_spi_miso(spi_miso), 

    .fifo_trans_dat_rdout_req(fifo_trans_dat_rdout_req),
    .fifo_trans_dat_rdout(fifo_trans_dat_rdout[7:0]),
    
    .fifo_trans_to_SDK_dat(fifo_trans_to_SDK_dat[7:0]),
    .fifo_trans_to_SDK_dval(fifo_trans_to_SDK_dval),
    .fifo_trans_to_SDK_fval(),

    .reg_rd_req(), 
    .reg_wr_req(reg_wr_en), 
    .reg_addr(reg_addr[7:0]), 
    .reg_val_wr_in(reg_datin[7:0]), 
    .reg_val_rd_out(reg_out[7:0])
    );


// ---------------- fifo input generate ------------------------------- //
gene_simple_fifo_dat gene_simple_fifo_dat_inst (
    .sys_clk(clk), 
    .rst_n(rst_n), 
    .fifo_trans_dat_rdout_req(fifo_trans_dat_rdout_req), 
    .fifo_trans_dat_rdout(fifo_trans_dat_rdout)
    );

// ---------------- fifo output --------------------------------------- //

// Instantiate the module
serial_fifo_dat_out serial_fifo_dat_out_inst (
    .sys_clk(clk), 
    .rst_n(rst_n), 
    .in_dval(fifo_trans_to_SDK_dval), 
    .in_dat(fifo_trans_to_SDK_dat[7:0]), 
    .out_dat_serial(fifo_out_dat_serial)
    );

// ----------------- internal registers ------------------------------- //
reg_port reg_port_inst (
    .clk(clk), 
    .rst_n(rst_n), 
    .reg_wr_en(reg_wr_en), 
    .reg_datin(reg_datin[7:0]), 
    .reg_addr(reg_addr[7:0]), 
    .reg_out(reg_out[7:0])
    );

endmodule
