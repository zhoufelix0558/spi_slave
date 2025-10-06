`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:08:51 10/06/2025 
// Design Name: 
// Module Name:    serial_fifo_dat_out 
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
module serial_fifo_dat_out(
    input   sys_clk,
    input   rst_n,
    input   in_dval,
    input[7:0]  in_dat,
    output reg  out_dat_serial
    );


reg[8:0]    in_dat_tmp;
reg[3:0]    send_cnt;

always @(posedge sys_clk or negedge rst_n) begin
    if(!rst_n)
        begin
            send_cnt    <=  'd0;
        end
    else if(send_cnt=='d0)
        begin
            if(in_dval=='d1)
                begin
                    send_cnt    <=  send_cnt    +   'd1;
                end
            else
                begin
                    send_cnt    <=  send_cnt;
                end
        end
    else if(send_cnt=='d9)
        begin
            send_cnt    <=  'd0;
        end
    else
        begin
            send_cnt    <=  send_cnt    +   'd1;
        end
end

always @(posedge sys_clk or negedge rst_n) begin
    if(!rst_n)
        begin
            in_dat_tmp    <=  'd0;
        end
    else if( (send_cnt=='d0)&&(in_dval=='d1) )
        begin
            if(in_dval=='d1)
                begin
                    in_dat_tmp[8:0] <= {in_dat[7:0],1'd0};
                end
            else
                begin
                    in_dat_tmp  <=  in_dat_tmp;
                end
        end
    else
        begin
            in_dat_tmp[8:0]    <=  {in_dat_tmp[0],in_dat_tmp[8:1]};
        end
end


always @(posedge sys_clk or negedge rst_n) begin
    if(!rst_n)
        begin
            out_dat_serial    <=  'd1;
        end
    else if( send_cnt>'d0 )
        begin
            out_dat_serial  <=  in_dat_tmp[0];
        end
    else
        begin
            out_dat_serial  <=  'd1;
        end
end



endmodule
