module spi_slave_ctrl (
    input                   sys_clk,
    input                   rst_n,

    //input[15:0]             data_bridge_rx_fifo_usedw,

    input                   st_spi_clk,
    input                   st_spi_mosi,
    input                   st_spi_ncs,
    output wire             st_spi_miso,

    input[7:0]              fifo_trans_dat_rdout,
    output reg              fifo_trans_dat_rdout_req,
    
    output reg[7:0]         fifo_trans_to_SDK_dat,  
    output reg              fifo_trans_to_SDK_dval, 
    output reg              fifo_trans_to_SDK_fval, 

    output reg              reg_wr_req,
    output reg              reg_rd_req,
    output reg[7:0]         reg_addr,
    input[7:0]             reg_val_rd_out,
    output reg[7:0]        reg_val_wr_in 
);

wire[7:0]         spi_dat_recv;            /* synthesis keep*/
wire              spi_dat_recv_dval;       /* synthesis keep*/
wire              spi_dat_recv_fval;       /* synthesis keep*/

reg               is_rx_fifo_sendout_done;
reg                 is_set_reg_done ;


reg[2:0]    cs;         /* synthesis keep*/
parameter   ST_IDLE                 =   'd0,
            ST_READ_FIFO_SDK        =   'd1,
            ST_WRITE_FIFO_SDK       =   'd2,
            ST_SET_REG              =   'd3,
            ST_GET_REG              =   'd4;

parameter   CMD_FPGA_READ_FIFO_SDK          =   8'h4C;
parameter   CMD_FPGA_SET_REG                =   8'h4D;
//parameter   CMD_FPGA_READ_ST_FIFO           =   8'h4E;
//parameter   CMD_FPGA_READ_FIFO_GRID         =   8'h4F;
parameter   CMD_FPGA_WRITE_FIFO_SDK         =   8'h50;
parameter   CMD_FPGA_GET_REG                =   8'h51;



reg     is_cmd_rd_fifo_st_flag;
reg     is_cmd_rd_fifo_grid_flag;
reg     is_cmd_rd_fifo_sdk_flag;
reg     is_cmd_wr_fifo_sdk_flag;
reg     is_cmd_set_reg_flag;
reg     is_cmd_get_reg_flag;


always@(posedge sys_clk or negedge rst_n)
begin
    if(!rst_n)
        begin
            cs  <=  'd0;
        end
    else
        begin
            case(cs)
                ST_IDLE:
                    begin
                        if(is_cmd_rd_fifo_sdk_flag=='d1)
                            begin
                                cs  <=  ST_READ_FIFO_SDK;
                            end
                        else if(is_cmd_wr_fifo_sdk_flag=='d1)
                            begin
                                cs  <=  ST_WRITE_FIFO_SDK;
                            end
                        else if(is_cmd_set_reg_flag=='d1)
                            begin
                                cs  <=  ST_SET_REG;
                            end
                        else if(is_cmd_get_reg_flag=='d1)
                            begin
                                cs  <=  ST_GET_REG;
                            end
                        else
                            begin
                                cs  <=  ST_IDLE;
                            end
                    end
                ST_READ_FIFO_SDK:   
                    begin
                        if(spi_dat_recv_fval=='d0)
                            begin
                                cs  <=  ST_IDLE;
                            end
                        else
                            begin
                                cs  <=  ST_READ_FIFO_SDK;
                            end
                    end
                ST_WRITE_FIFO_SDK:
                    begin
                        if(spi_dat_recv_fval=='d0)
                            begin
                                cs  <=  ST_IDLE;
                            end
                        else
                            begin
                                cs  <=  ST_WRITE_FIFO_SDK;
                            end
                    end
                ST_SET_REG:
                    begin
                        if(spi_dat_recv_fval=='d0)
                            begin
                                cs  <=  ST_IDLE;
                            end
                        // else if(is_set_reg_done=='d1)
                        //     begin
                        //         cs  <=  ST_IDLE;
                        //     end
                        else
                            begin
                                cs  <=  ST_SET_REG;
                            end
                    end
                ST_GET_REG:
                    begin
                        if(spi_dat_recv_fval=='d0)
                            begin
                                cs  <=  ST_IDLE;
                            end
                        else
                            begin
                                cs  <=  ST_GET_REG;
                            end
                    end
            default:
                begin
                    cs  <=  ST_IDLE;
                end
            endcase
        end
end



always@(posedge sys_clk or negedge rst_n)
begin
    if(!rst_n)
        begin
            is_cmd_rd_fifo_sdk_flag         <=  'd0;
            is_cmd_wr_fifo_sdk_flag         <=  'd0;
            is_cmd_set_reg_flag             <=  'd0;
            is_cmd_get_reg_flag             <=  'd0;
        end
    else
        begin
            if(cs==ST_IDLE)
                begin
                    if(spi_dat_recv_dval=='d1)
                        begin
                            if(spi_dat_recv==CMD_FPGA_READ_FIFO_SDK)
                                begin
                                    is_cmd_rd_fifo_sdk_flag     <=  'd1;
                                end
                            else if(spi_dat_recv==CMD_FPGA_WRITE_FIFO_SDK)
                                begin
                                    is_cmd_wr_fifo_sdk_flag     <=  'd1;
                                end
                            else if(spi_dat_recv==CMD_FPGA_SET_REG)
                                begin
                                    is_cmd_set_reg_flag     <=  'd1;
                                end
                            else if(spi_dat_recv==CMD_FPGA_GET_REG)
                                begin
                                    is_cmd_get_reg_flag     <=  'd1;
                                end
                            else    
                                begin
                                    is_cmd_rd_fifo_st_flag <=  'd0;
                                end
                        end
                    else
                        begin
                            is_cmd_rd_fifo_st_flag          <=  'd0;
                            is_cmd_rd_fifo_grid_flag        <=  'd0;
                            is_cmd_rd_fifo_sdk_flag         <=  'd0;
                            is_cmd_set_reg_flag             <=  'd0;
                            is_cmd_get_reg_flag             <=  'd0;
                        end
                end
            else if(cs==ST_READ_FIFO_SDK)
                begin
                    is_cmd_rd_fifo_sdk_flag     <=  'd0;   
                end
            else if(cs==ST_WRITE_FIFO_SDK)
                begin
                    is_cmd_wr_fifo_sdk_flag     <=  'd0;
                end
            else if(cs==ST_SET_REG)
                begin
                    is_cmd_set_reg_flag         <=  'd0;
                end
            else if(cs==ST_GET_REG)
                begin
                    is_cmd_get_reg_flag         <=  'd0;    
                end
            else
                begin
                    is_cmd_rd_fifo_sdk_flag     <=  'd0;
                    is_cmd_wr_fifo_sdk_flag     <=  'd0;
                    is_cmd_set_reg_flag         <=  'd0;
                    is_cmd_get_reg_flag         <=  'd1;
                end
        end
end



reg         st_spi_clk_d;
reg         st_spi_clk_d1;
// 2**13=8096 (0.5Byte)
reg[12:0]   spi_clk_falling_edge_cnt;      /* synthesis keep */
reg[12:0]   spi_clk_rising_edge_cnt;      /* synthesis keep */
always@(posedge sys_clk)
begin
    st_spi_clk_d   <=  st_spi_clk;
    st_spi_clk_d1   <=  st_spi_clk_d;
end

always@(posedge sys_clk or negedge rst_n)
begin
    if(!rst_n)
        begin
            spi_clk_falling_edge_cnt   <=  'd0;
        end
    else if( st_spi_ncs=='d1 )
        begin
            spi_clk_falling_edge_cnt   <=  'd0;
        end
    //else if( (st_spi_clk_d=='d1)&&(st_spi_clk=='d0) )
    // buffered clk falling edge
    else if( (st_spi_clk_d1=='d1)&&(st_spi_clk_d=='d0) )
        begin
            spi_clk_falling_edge_cnt   <=  spi_clk_falling_edge_cnt   +   'd1;
        end
    else
        begin
            spi_clk_falling_edge_cnt   <=  spi_clk_falling_edge_cnt;
        end
end

always@(posedge sys_clk or negedge rst_n)
begin
    if(!rst_n)
        begin
            spi_clk_rising_edge_cnt   <=  'd0;
        end
    else if( st_spi_ncs=='d1 )
        begin
            spi_clk_rising_edge_cnt   <=  'd0;
        end
    // buffered clk rising edge
    else if( (st_spi_clk_d1=='d0)&&(st_spi_clk_d=='d1) )
        begin
            spi_clk_rising_edge_cnt   <=  spi_clk_rising_edge_cnt   +   'd1;
        end
    else
        begin
            spi_clk_rising_edge_cnt   <=  spi_clk_rising_edge_cnt;
        end
end


reg[7:0]        spi_out_byte;

always@(posedge sys_clk or negedge rst_n)
begin
    if(!rst_n)
        begin
            fifo_trans_dat_rdout_req    <=  'd0;
            reg_rd_req                  <=  'd0;
        end
    else
        begin
            if(cs==ST_IDLE)
                begin
                    reg_rd_req                  <=  'd0;
                    fifo_trans_dat_rdout_req    <=  'd0;
                end

            // 读取外部SDK的传过来的数据
            else if(cs==ST_READ_FIFO_SDK)
                begin                    
                    if(spi_dat_recv_dval=='d1)
                        begin
                            fifo_trans_dat_rdout_req    <=  'd1;
                        end
                    else
                        begin
                            fifo_trans_dat_rdout_req    <=  'd0;
                        end
                end
            else if(cs==ST_GET_REG)
                begin     
                    if(spi_dat_recv_dval=='d1)
                        begin
                            reg_rd_req  <=  'd1;
                        end
                    else
                        begin
                            reg_rd_req  <=  'd0;
                        end
                end
            else
                begin
                    fifo_trans_dat_rdout_req        <=  'd0;
                    reg_rd_req                      <=  'd0;
                end
        end
end


reg[2:0]    reg_wr_cnt;
reg         is_reg_addr_assigned;
always@(posedge sys_clk or negedge rst_n)
begin
    if(!rst_n)
        begin
            reg_wr_req              <=  'd0;
            reg_wr_cnt              <=  'd0;
            reg_addr                <=  'd0;
            reg_val_wr_in           <=  'd0;
            is_reg_addr_assigned    <=  'd0;
        end
    else
        begin
            if(cs==ST_SET_REG)
                begin
                    if(spi_dat_recv_dval=='d1)
                        begin
                            if(is_reg_addr_assigned=='d0)
                                begin
                                    reg_addr[7:0]   <=  spi_dat_recv[7:0] - 'd1;    // +1 when next wr_req
                                    is_reg_addr_assigned    <=  'd1;
                                end
                            else
                                begin
                                    reg_val_wr_in   <=  spi_dat_recv;
                                    reg_wr_req      <=  'd1;
                                    reg_addr        <=  reg_addr    +   'd1;
                                end
                        end     
                    else    
                        begin
                            reg_wr_req          <=  'd0;
                        end              
                end
            else if(cs==ST_GET_REG)
                begin
                    if(spi_dat_recv_dval=='d1)
                        begin
                            if(is_reg_addr_assigned=='d0)
                                begin
                                    reg_addr[7:0]   <=  spi_dat_recv[7:0];
                                    is_reg_addr_assigned    <=  'd1;
                                end
                            else
                                begin
                                    reg_addr    <=  reg_addr    +   'd1;
                                end
                        end     
                    else    
                        begin
                            
                        end   
                end
            else
                begin
                    reg_wr_req              <=  'd0;
                    reg_wr_cnt              <=  'd0;
                    reg_addr                <=  'd0;
                    reg_val_wr_in           <=  'd0;
                    is_reg_addr_assigned    <=  'd0;
                end
        end

end

always@(posedge sys_clk or negedge rst_n)
begin
    if(!rst_n)
        begin
            fifo_trans_to_SDK_dat[7:0]      <=  'd0;
            fifo_trans_to_SDK_dval          <=  'd0;
            fifo_trans_to_SDK_fval          <=  'd0;
        end
    else
        begin
            if(cs==ST_WRITE_FIFO_SDK)
                begin
                    fifo_trans_to_SDK_fval  <=  'd1;
                    if(spi_dat_recv_dval=='d1)
                        begin
                            fifo_trans_to_SDK_dat[7:0]      <=  spi_dat_recv[7:0];
                            fifo_trans_to_SDK_dval          <=  'd1;
                        end     
                    else    
                        begin
                            fifo_trans_to_SDK_dval          <=  'd0;
                        end              
                end
            else
                begin
                    fifo_trans_to_SDK_dat[7:0]      <=  'd0;
                    fifo_trans_to_SDK_dval          <=  'd0;
                    fifo_trans_to_SDK_fval          <=  'd0;
                end
        end

end





spi_slave_core spi_slave_core (
    .sys_clk(sys_clk),
    .rst_n(rst_n),
    .st_spi_mosi(st_spi_mosi),
    .st_spi_clk(st_spi_clk),
    .st_spi_ncs(st_spi_ncs),
    .st_spi_miso(st_spi_miso),
    
    .spi_out_byte(spi_out_byte),    

    .spi_dat_recv(spi_dat_recv),
    .spi_dat_recv_dval(spi_dat_recv_dval),
    .spi_dat_recv_fval(spi_dat_recv_fval)
);      



always@(posedge sys_clk or negedge rst_n)
begin
    if(!rst_n)
        begin   
            spi_out_byte    <=  'd0;
        end
    else if(cs==ST_GET_REG)
        begin
            spi_out_byte    <=  reg_val_rd_out;
        end
    else
        begin
            spi_out_byte    <=  fifo_trans_dat_rdout;
        end
end


                
endmodule
