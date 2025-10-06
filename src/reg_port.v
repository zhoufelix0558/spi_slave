module reg_port
(
    input               clk,
    input               rst_n,

    input               reg_wr_en,
    input[7:0]          reg_datin,
    input[7:0]          reg_addr,
    output reg[7:0]     reg_out
);

// ------------------------------ change log ------------------------------------------------//
reg[23:0]   reg_readonly;       // reg00-02
reg[15:0]   reg_write;          // reg03-04


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        begin

            reg_readonly[23:0]  <=  24'h464549;     // 'F'  'E' 'I'

            reg_write[15:0]     <=  16'h1234;

        end
    else
        begin
            if(reg_wr_en=='d1)
                begin
                    case(reg_addr)
                        'h03:   reg_write[7:0]   <=  reg_datin;
                        'h04:   reg_write[15:8]   <=  reg_datin;
                        default:
                            begin

                            end
                    endcase

                end
            else
                begin
                end

        end
end




always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        begin
            reg_out      <=  'd0;
        end
    else
        begin
            // if(reg_rd_en)
                begin
                    case(reg_addr)
                        'h00:   reg_out     <=  reg_readonly[7:0];
                        'h01:   reg_out     <=  reg_readonly[15:8]; 
                        'h02:   reg_out     <=  reg_readonly[23:16]; 

                        'h03:   reg_out     <=  reg_write[7:0]; 
                        'h04:   reg_out     <=  reg_write[15:8]; 
                        
                        default:
                            begin
                                reg_out     <=  'd0;
                            end
                    endcase

                end
            // else
            //     begin

            //     end

        end
end



endmodule
