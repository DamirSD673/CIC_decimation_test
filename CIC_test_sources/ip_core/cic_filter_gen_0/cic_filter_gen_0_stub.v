// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Mon Feb 13 14:02:18 2023
// Host        : damir-VivoBook-ASUSLaptop-X512DK-X512DK running 64-bit Ubuntu 22.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/damir/vivado_scripts/CIC_test/CIC_test_sources/ip_core/cic_filter_gen_0/cic_filter_gen_0_stub.v
// Design      : cic_filter_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k70tfbv676-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "cic_compiler_v4_0_15,Vivado 2019.2" *)
module cic_filter_gen_0(aclk, s_axis_data_tdata, s_axis_data_tvalid, 
  s_axis_data_tready, m_axis_data_tdata, m_axis_data_tvalid)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_data_tdata[15:0],s_axis_data_tvalid,s_axis_data_tready,m_axis_data_tdata[15:0],m_axis_data_tvalid" */;
  input aclk;
  input [15:0]s_axis_data_tdata;
  input s_axis_data_tvalid;
  output s_axis_data_tready;
  output [15:0]m_axis_data_tdata;
  output m_axis_data_tvalid;
endmodule
