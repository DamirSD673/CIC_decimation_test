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
    wire [15:0] sin_out; // Sinus generator out
    wire [15:0] sin_dem; // Filtered signal
    
    integer decimated_signal = 0;


    // Sinus generator (Sum of cos, fs = 1 MHz, f_1 = )
    sinus_generator #(.LENGTH(1000)) dut(
                        .clk(clk),
                        .sinus(sin_out)
                        );

    // CIC filtered signal;
    cic_filter_gen_0 filter(
                            .aclk(clk),
                            .s_axis_data_tdata(sin_out),
                            .s_axis_data_tvalid(1),
                            .m_axis_data_tdata(sin_dem)
                            );
                            
    initial begin
    clk = 0;
    clk_down = 0;
    $display("Clocks set up");
    decimated_signal = $fopen("../../../../../CIC_test_sources/sin_dec_out.txt", "w");
    
    // Slower clock (rate R = 4, 0.25 MSps = 0.25 Mhz)
    forever begin
        #3500 clk_down = ~clk_down;
        #500 clk_down = ~clk_down;
    end
        
    end
    
    always @(posedge clk_down)
    begin
        out_data <= sin_dem[15:0];
        $fwrite(decimated_signal, "%d \n", $unsigned(out_data)); // Write signal output in text file
    end
    
    // Initial clock (1 MSps = 1 MHz)
    always 
        #500 clk = ~clk;
        
    always begin
        #1e9 $fclose(decimated_signal);
        $display("File written");
    end
endmodule
