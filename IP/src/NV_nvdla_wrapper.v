`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2023 09:43:51 PM
// Design Name: 
// Module Name: NV_nvdla_wrapper
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

module NV_nvdla_wrapper(
    input core_clk,
    input csb_clk,
    input rstn,
    input csb_rstn,

    output dla_intr,
    // dbb AXI
    output m_axi_awvalid,
    input m_axi_awready,
    output [7:0] m_axi_awid,
    output [3:0] m_axi_awlen,
    output [2:0] m_axi_awsize,
    output [64 -1:0] m_axi_awaddr,
    output m_axi_wvalid,
    input m_axi_wready,
    output [64 -1:0] m_axi_wdata,
    output [64/8-1:0] m_axi_wstrb,
    output m_axi_wlast,
    output m_axi_arvalid,
    input m_axi_arready,
    output [7:0] m_axi_arid,
    output [3:0] m_axi_arlen,
    output [2:0] m_axi_arsize,
    output [64 -1:0] m_axi_araddr,
    input m_axi_bvalid,
    output m_axi_bready,
    input [7:0] m_axi_bid,
    input m_axi_rvalid,
    output m_axi_rready,
    input [7:0] m_axi_rid,
    input m_axi_rlast,
    input [64 -1:0] m_axi_rdata,
    output [1:0] m_axi_awburst,
    output  m_axi_awlock,
    output [3:0] m_axi_awcache,
    output [2:0] m_axi_awprot,
    output [3:0] m_axi_awqos,
    output  m_axi_awuser,
    output  m_axi_wuser,
    input  [1:0] m_axi_bresp,
    input   m_axi_buser,
    output [1:0] m_axi_arburst,
    output  m_axi_arlock,
    output [3:0] m_axi_arcache,
    output [2:0] m_axi_arprot,
    output [3:0] m_axi_arqos,
    output  m_axi_aruser,
    input  [1:0] m_axi_rresp,
    input   m_axi_ruser,
    // cfg APB
    input psel,
    input penable,
    input pwrite,
    input [31:0] paddr,
    input [31:0] pwdata,
    output [31:0] prdata,
    output pready,
    output pslverr
    );

    // dbb AXI from the perpective of nvdla_core2dbb
    wire nvdla_core2dbb_aw_awvalid = m_axi_awvalid;
    wire nvdla_core2dbb_aw_awready = m_axi_awready;
    wire [7:0] nvdla_core2dbb_aw_awid = m_axi_awid;
    wire [3:0] nvdla_core2dbb_aw_awlen = m_axi_awlen; 
    wire [2:0] nvdla_core2dbb_aw_awsize = m_axi_awsize;
    wire [64 -1:0] nvdla_core2dbb_aw_awaddr = m_axi_awaddr;
    wire nvdla_core2dbb_w_wvalid = m_axi_wvalid;
    wire nvdla_core2dbb_w_wready = m_axi_wready;
    wire [64 -1:0] nvdla_core2dbb_w_wdata = m_axi_wdata;
    wire [64/8-1:0] nvdla_core2dbb_w_wstrb = m_axi_wstrb;
    wire nvdla_core2dbb_w_wlast = m_axi_wlast;
    wire nvdla_core2dbb_ar_arvalid = m_axi_arvalid;
    wire nvdla_core2dbb_ar_arready = m_axi_arready;
    wire [7:0] nvdla_core2dbb_ar_arid = m_axi_arid;
    wire [3:0] nvdla_core2dbb_ar_arlen = m_axi_arlen;
    wire [2:0] nvdla_core2dbb_ar_arsize = m_axi_arsize;
    wire [64 -1:0] nvdla_core2dbb_ar_araddr = m_axi_araddr;
    wire nvdla_core2dbb_b_bvalid = m_axi_bvalid;
    wire nvdla_core2dbb_b_bready = m_axi_bready;
    wire [7:0] nvdla_core2dbb_b_bid = m_axi_bid;
    wire nvdla_core2dbb_r_rvalid = m_axi_rvalid;
    wire nvdla_core2dbb_r_rready = m_axi_rready;
    wire [7:0] nvdla_core2dbb_r_rid = m_axi_rid;
    wire nvdla_core2dbb_r_rlast = m_axi_rlast;
    wire [64 -1:0] nvdla_core2dbb_r_rdata = m_axi_rdata;

    wire        m_csb2nvdla_valid;
    wire        m_csb2nvdla_ready;
    wire [15:0] m_csb2nvdla_addr;
    wire [31:0] m_csb2nvdla_wdat;
    wire        m_csb2nvdla_write;
    wire        m_csb2nvdla_nposted;
    wire        m_nvdla2csb_valid;
    wire [31:0] m_nvdla2csb_data;


    NV_NVDLA_apb2csb apb2csb (
        .pclk                  (csb_clk)
        ,.prstn                 (csb_rstn)
        ,.csb2nvdla_ready       (m_csb2nvdla_ready)
        ,.nvdla2csb_data        (m_nvdla2csb_data)
        ,.nvdla2csb_valid       (m_nvdla2csb_valid)
        ,.paddr                 (paddr)
        ,.penable               (penable)
        ,.psel                  (psel)
        ,.pwdata                (pwdata)
        ,.pwrite                (pwrite)
        ,.csb2nvdla_addr        (m_csb2nvdla_addr)
        ,.csb2nvdla_nposted     (m_csb2nvdla_nposted)
        ,.csb2nvdla_valid       (m_csb2nvdla_valid)
        ,.csb2nvdla_wdat        (m_csb2nvdla_wdat)
        ,.csb2nvdla_write       (m_csb2nvdla_write)
        ,.prdata                (prdata)
        ,.pready                (pready)
    );


    NV_nvdla nvdla_top (
        .dla_core_clk                    (core_clk)
        ,.dla_csb_clk                     (csb_clk)
        ,.global_clk_ovr_on               (1'b0)
        ,.tmc2slcg_disable_clock_gating   (1'b0)
        ,.dla_reset_rstn                  (rstn)
        ,.direct_reset_                   (1'b1)
        ,.test_mode                       (1'b0)
        ,.csb2nvdla_valid                 (m_csb2nvdla_valid)
        ,.csb2nvdla_ready                 (m_csb2nvdla_ready)
        ,.csb2nvdla_addr                  (m_csb2nvdla_addr)
        ,.csb2nvdla_wdat                  (m_csb2nvdla_wdat)
        ,.csb2nvdla_write                 (m_csb2nvdla_write)
        ,.csb2nvdla_nposted               (m_csb2nvdla_nposted)
        ,.nvdla2csb_valid                 (m_nvdla2csb_valid)
        ,.nvdla2csb_data                  (m_nvdla2csb_data)
        ,.nvdla2csb_wr_complete           () //FIXME: no such port in apb2csb
        ,.nvdla_core2dbb_aw_awvalid       (nvdla_core2dbb_aw_awvalid)
        ,.nvdla_core2dbb_aw_awready       (nvdla_core2dbb_aw_awready)
        ,.nvdla_core2dbb_aw_awaddr        (nvdla_core2dbb_aw_awaddr)
        ,.nvdla_core2dbb_aw_awid          (nvdla_core2dbb_aw_awid)
        ,.nvdla_core2dbb_aw_awlen         (nvdla_core2dbb_aw_awlen)
        ,.nvdla_core2dbb_w_wvalid         (nvdla_core2dbb_w_wvalid)
        ,.nvdla_core2dbb_w_wready         (nvdla_core2dbb_w_wready)
        ,.nvdla_core2dbb_w_wdata          (nvdla_core2dbb_w_wdata)
        ,.nvdla_core2dbb_w_wstrb          (nvdla_core2dbb_w_wstrb)
        ,.nvdla_core2dbb_w_wlast          (nvdla_core2dbb_w_wlast)
        ,.nvdla_core2dbb_b_bvalid         (nvdla_core2dbb_b_bvalid)
        ,.nvdla_core2dbb_b_bready         (nvdla_core2dbb_b_bready)
        ,.nvdla_core2dbb_b_bid            (nvdla_core2dbb_b_bid)
        ,.nvdla_core2dbb_ar_arvalid       (nvdla_core2dbb_ar_arvalid)
        ,.nvdla_core2dbb_ar_arready       (nvdla_core2dbb_ar_arready)
        ,.nvdla_core2dbb_ar_araddr        (nvdla_core2dbb_ar_araddr)
        ,.nvdla_core2dbb_ar_arid          (nvdla_core2dbb_ar_arid)
        ,.nvdla_core2dbb_ar_arlen         (nvdla_core2dbb_ar_arlen)
        ,.nvdla_core2dbb_r_rvalid         (nvdla_core2dbb_r_rvalid)
        ,.nvdla_core2dbb_r_rready         (nvdla_core2dbb_r_rready)
        ,.nvdla_core2dbb_r_rid            (nvdla_core2dbb_r_rid)
        ,.nvdla_core2dbb_r_rlast          (nvdla_core2dbb_r_rlast)
        ,.nvdla_core2dbb_r_rdata          (nvdla_core2dbb_r_rdata)
        ,.dla_intr                        (dla_intr)
        ,.nvdla_pwrbus_ram_c_pd           (32'b0)
        ,.nvdla_pwrbus_ram_ma_pd          (32'b0)
        ,.nvdla_pwrbus_ram_mb_pd          (32'b0)
        ,.nvdla_pwrbus_ram_p_pd           (32'b0)
        ,.nvdla_pwrbus_ram_o_pd           (32'b0)
        ,.nvdla_pwrbus_ram_a_pd           (32'b0)
    ); // nvdla_top

assign nvdla_core2dbb_aw_awsize = 3'b011;
assign nvdla_core2dbb_ar_arsize = 3'b011;

assign m_axi_awburst = 2'b01;
assign m_axi_awlock  = 1'b0;
assign m_axi_awcache = 4'b0010;
assign m_axi_awprot  = 3'h0;
assign m_axi_awqos   = 4'h0;
assign m_axi_awuser  = 'b1;
assign m_axi_wuser   = 'b0;
assign m_axi_arburst = 2'b01;
assign m_axi_arlock  = 1'b0;
assign m_axi_arcache = 4'b0010;
assign m_axi_arprot  = 3'h0;
assign m_axi_arqos   = 4'h0;
assign m_axi_aruser  = 'b1;

assign pslverr = 1'b0;

endmodule
