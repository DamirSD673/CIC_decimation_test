`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2023 01:09:50 PM
// Design Name: 
// Module Name: tb_sinus
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_sinus(
    );

    reg clk;
    reg clk_down;
    reg [15:0] out_data; // Decimated signal after filtering
    reg [15:0] out_allias_data; // alliased data
    wire [15:0] sin_out; // Sinus generator out
    wire [15:0] sin_dem; // Filtered signal
    wire [15:0] sin_fir; // FIR filtered signal
    wire m_axis_tvalid_cic;
    wire s_axis_config_tready;
    
    integer decimated_signal = 0;
    integer decimated_allias_signal = 0;
    integer fir_out = 0;
    integer count;

    reg s_axis_data_tvalid = 1;
    reg change_rate = 0;
    reg s_axis_config_tvalid;
    reg [7:0] s_axis_config_tdata_cic;
    reg [7:0] s_axis_config_tdata_fir;

    // Sinus generator (Sum of cos, fs = 1 MHz, f_1 = )
    sinus_generator #(.LENGTH(1000)) dut(
                        .clk(clk),
                        .sinus(sin_out)
                        );

    // CIC filtered signal;
    cic_filter_gen_0 filter(
                            .aclk(clk),
                            .s_axis_data_tdata(sin_out),
                            .s_axis_data_tvalid(s_axis_data_tvalid),
                            .s_axis_config_tdata(s_axis_config_tdata_cic),
                            .s_axis_config_tvalid(s_axis_config_tvalid),
                            .s_axis_config_tready(s_axis_config_tready),
                            .m_axis_data_tdata(sin_dem),
                            .m_axis_data_tvalid(m_axis_tvalid_cic)
                            );
                            
    // FIR compensated signal
    
    fir_gen_0 fir_filter(
                              .aclk(m_axis_tvalid_cic),
                              .s_axis_data_tdata(sin_dem),
                              .s_axis_data_tvalid(m_axis_tvalid_cic),
                              .s_axis_config_tdata(s_axis_config_tdata_fir),
                              .s_axis_config_tvalid(s_axis_config_tvalid),
                              .m_axis_data_tdata(sin_fir)
                              );

    

    initial
    begin
        clk = 0;
        clk_down = 0;
        count = 0;
        s_axis_config_tdata_cic = $unsigned(4);
        s_axis_config_tdata_fir = 8'h00;

        $display("Clocks set up");
        //decimated_signal = $fopen("../../../../../CIC_test_sources/sin_dec_out.txt", "w");
        //decimated_allias_signal = $fopen("../../../../../CIC_test_sources/sin_dec_allias_out.txt", "w");
        
        // Slower clock (rate R = 4, 0.25 MSps = 0.25 Mhz)
        forever begin
            #3500 clk_down = ~clk_down;
            #500 clk_down = ~clk_down;
        end
        
    end

    always @(posedge clk)
    begin
        count = count + 1;
    end

    always @(posedge clk) begin
        s_axis_config_tvalid <= (s_axis_config_tready == 1 && change_rate == 1) ? 1:0;
        change_rate <= 0;
        //#500 s_axis_config_tvalid <= 0;
    end
    
    /*
    always @(posedge clk) begin
        s_axis_config_tdata_fir = (count >= 999) ? 8'h00:8'h01;
    end
    */
    
    // Initial clock (1 MSps = 1 MHz)
    always 
        #500 clk = ~clk;
        
    always @(posedge clk) begin
        //#1e9 $fclose(decimated_signal);
        //$fclose(decimated_allias_signal);
        if (count == 5) begin
            change_rate <= 1;
        end else begin
            change_rate <= 0;
        end
    end
endmodule
