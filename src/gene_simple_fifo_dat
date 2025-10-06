`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:01:04 10/06/2025 
// Design Name: 
// Module Name:    gene_simple_fifo_dat 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module gene_simple_fifo_dat(
    input               sys_clk,
    input               rst_n,
    input               fifo_trans_dat_rdout_req,
    output reg[7:0]     fifo_trans_dat_rdout
    );


always @(posedge sys_clk or negedge rst_n) 
begin
    if(!rst_n)
        begin
            fifo_trans_dat_rdout    <=  'd0;
        end
    else if(fifo_trans_dat_rdout_req=='d1)
        begin
            fifo_trans_dat_rdout    <=  fifo_trans_dat_rdout    +   'd1;
        end  
    else
        begin
            fifo_trans_dat_rdout    <=  fifo_trans_dat_rdout;
        end      
end

endmodule
