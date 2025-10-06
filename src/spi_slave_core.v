`timescale 1ns / 1ps
module spi_slave_core (
    input                   sys_clk,
    input                   rst_n,

    input                   st_spi_mosi,
    input                   st_spi_clk,
    input                   st_spi_ncs,
    output  reg             st_spi_miso,

    input[7:0]              spi_out_byte,

    // data recved
    output reg[7:0]         spi_dat_recv,
    output reg              spi_dat_recv_dval,
    output reg              spi_dat_recv_fval

);

// ------------------------------------ spi data in ------------------------------------ //


reg st_spi_clk_d;  /* synthesis keep*/
reg st_spi_clk_d1; /* synthesis keep*/
reg st_spi_mosi_d;
reg st_spi_mosi_d1;
reg st_spi_ncs_d;

always @(posedge sys_clk or negedge rst_n) 
begin
    if(!rst_n)
        begin
            st_spi_clk_d    <=  'd0;
            st_spi_clk_d1   <=  'd0;
            st_spi_ncs_d     <=  'd1;       // spi_ncs默认高电平
            st_spi_mosi_d   <=  'd0;
            st_spi_mosi_d1  <=  'd0;
        end
    else
        begin
            st_spi_clk_d    <=  st_spi_clk;
            st_spi_clk_d1   <=  st_spi_clk_d;
            st_spi_ncs_d     <=  st_spi_ncs;
            st_spi_mosi_d   <=  st_spi_mosi;
            st_spi_mosi_d1  <=  st_spi_mosi_d;
        end    
end



always @(posedge sys_clk or negedge rst_n) 
begin
    if(!rst_n)
        begin
            spi_dat_recv_fval   <=  'd0;
        end
    else    
        begin
            spi_dat_recv_fval   <=  ~st_spi_ncs_d;
        end
end



reg[3:0]   spi_clk_cnt    ;   /* synthesis keep*/
reg[7:0]    spi_dat_recv_tmp; /* synthesis keep*/

always @(posedge sys_clk or negedge rst_n) 
begin
   if( (!rst_n)||(st_spi_ncs_d=='d1))
        begin
            spi_clk_cnt         <=  'd0;
            spi_dat_recv_tmp    <=  'd0;
            spi_dat_recv        <=  'd0;
            spi_dat_recv_dval   <=  'd0;
        end
    else
        // rising edge --> store data
        if((st_spi_clk_d1=='d0)&&(st_spi_clk_d=='d1))
            begin
                if(spi_clk_cnt=='d7)
                    begin
                        spi_clk_cnt         <=  'd0;
                        spi_dat_recv_dval   <=  'd1;
                        spi_dat_recv[7:0]   <=  {spi_dat_recv_tmp[6:0],st_spi_mosi_d1};
                    end
                else
                    begin
                        spi_clk_cnt         <=  spi_clk_cnt +   'd1;
                        spi_dat_recv_dval   <=  'd0;
                    end
                spi_dat_recv_tmp[7:0]       <=  {spi_dat_recv_tmp[6:0],st_spi_mosi_d1};
            end
        else
            begin
                spi_clk_cnt                 <=  spi_clk_cnt;
                spi_dat_recv_dval           <=  'd0;
            end
end



// ------------------------------------ spi data out ------------------------------------ //
// buffer data when spi_dat_recv_dval==1,output when rising edge(show ahead several clk) 
// 
reg[7:0]    spi_out_byte_tmp; /* synthesis keep*/


always @(posedge sys_clk or negedge rst_n) 
begin
    if( (!rst_n)||(st_spi_ncs_d=='d1))
        begin
            spi_out_byte_tmp    <=  spi_out_byte;
        end
    else
        begin
            // rising edge 
            if((st_spi_clk_d1=='d0)&&(st_spi_clk_d=='d1))  
                begin
                    if(spi_clk_cnt=='d7)
                        begin
                            spi_out_byte_tmp[7:0]   <=  spi_out_byte[7:0];
                        end
                    else
                        begin
                            spi_out_byte_tmp[7:0]   <=  {spi_out_byte_tmp[6:0],1'd0};
                        end
                end
            else
                begin
                    spi_out_byte_tmp    <=  spi_out_byte_tmp;
                end            
        end
end


always @(*) 
begin
    st_spi_miso <=  spi_out_byte_tmp[7];
end


endmodule
