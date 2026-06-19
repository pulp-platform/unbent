// Copyright 2023 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Michael Rogenmoser <michaero@iis.ee.ethz.ch>

/// Baseline bus error unit
module bus_err_unit #(
  parameter int unsigned AddrWidth       = 48,
  parameter int unsigned MetaDataWidth   = 1,
  parameter int unsigned ErrBits         = 3,
  parameter int unsigned NumOutstanding  = 4,
  parameter int unsigned NumStoredErrors = 4,
  parameter int unsigned NumReqPorts     = 1,
  parameter int unsigned NumChannels     = 1, // Channels are one-hot!
  parameter bit          DropOldest      = 1'b0,
  parameter type         apb_req_t       = logic,
  parameter type         apb_rsp_t       = logic
) (
  input  logic                                      clk_i,
  input  logic                                      rst_ni,
  input  logic                                      testmode_i,

  input  logic [NumReqPorts-1:0][  NumChannels-1:0] req_hs_valid_i,
  input  logic [NumReqPorts-1:0][    AddrWidth-1:0] req_addr_i,
  input  logic [NumReqPorts-1:0][MetaDataWidth-1:0] req_meta_i,
  input  logic                  [  NumChannels-1:0] rsp_hs_valid_i,
  input  logic                  [  NumChannels-1:0] rsp_burst_last_i,
  input  logic                  [      ErrBits-1:0] rsp_err_i,

  output logic                                      err_irq_o,

  input  apb_req_t                                  apb_req_i,
  output apb_rsp_t                                  apb_rsp_o

);

  logic [    AddrWidth-1:0] read_err_addr;
  logic [MetaDataWidth-1:0] read_err_meta;
  logic [      ErrBits-1:0] read_err_err;
  logic                     read_err_overflow;

  bus_err_unit_reg_pkg::bus_err_unit__out_t reg2hw;
  bus_err_unit_reg_pkg::bus_err_unit__in_t hw2reg;

  assign hw2reg.err_addr.rd_data.err_addr = read_err_addr[31:0];
  if (AddrWidth > 32) begin
    always_comb begin
      hw2reg.err_addr_top.rd_data.err_addr_top = '0;
      hw2reg.err_addr_top.rd_data.err_addr_top[AddrWidth-32-1:0] = read_err_addr[AddrWidth-1:32];
    end
  end else begin
    assign hw2reg.err_addr_top.rd_data.err_addr_top = '0;
  end
  always_comb begin : proc_err_code
    hw2reg.err_code.rd_data.err_code = '0;
    hw2reg.err_code.rd_data.err_code[ErrBits-1:0] = read_err_err;
    hw2reg.err_code.rd_data.err_code[31] = read_err_overflow;
  end
  always_comb begin
    hw2reg.meta.rd_data.meta = '0;
    hw2reg.meta.rd_data.meta[MetaDataWidth-1:0] = read_err_meta;
  end

  assign hw2reg.err_addr.rd_ack = reg2hw.err_addr.req & ~reg2hw.err_addr.req_is_wr;
  assign hw2reg.err_addr_top.rd_ack = reg2hw.err_addr_top.req & ~reg2hw.err_addr_top.req_is_wr;
  assign hw2reg.err_code.rd_ack = reg2hw.err_code.req & ~reg2hw.err_code.req_is_wr;
  assign hw2reg.meta.rd_ack = reg2hw.meta.req & ~reg2hw.meta.req_is_wr;

  bus_err_unit_reg_top i_regs (
    .clk (clk_i),
    .arst_n (rst_ni),
    .s_apb_psel    (apb_req_i.psel),
    .s_apb_penable (apb_req_i.penable),
    .s_apb_pwrite  (apb_req_i.pwrite),
    .s_apb_pprot   (apb_req_i.pprot),
    .s_apb_paddr   (apb_req_i.paddr[bus_err_unit_reg_pkg::BUS_ERR_UNIT_REG_TOP_MIN_ADDR_WIDTH-1:0]),
    .s_apb_pwdata  (apb_req_i.pwdata),
    .s_apb_pstrb   (apb_req_i.pstrb),
    .s_apb_pready  (apb_rsp_o.pready),
    .s_apb_prdata  (apb_rsp_o.prdata),
    .s_apb_pslverr (apb_rsp_o.pslverr),
    .hwif_out (reg2hw),
    .hwif_in (hw2reg)
  );

  bus_err_unit_bare #(
    .AddrWidth      ( AddrWidth       ),
    .MetaDataWidth  ( MetaDataWidth   ),
    .ErrBits        ( ErrBits         ),
    .NumOutstanding ( NumOutstanding  ),
    .NumStoredErrors( NumStoredErrors ),
    .NumReqPorts    ( NumReqPorts     ),
    .NumChannels    ( NumChannels     ),
    .DropOldest     ( DropOldest      )
  ) i_err_unit_bare (
    .clk_i,
    .rst_ni,
    .testmode_i,

    .req_hs_valid_i,
    .req_addr_i,
    .req_meta_i,
    .rsp_hs_valid_i,
    .rsp_burst_last_i,
    .rsp_err_i,

    .err_irq_o,

    .err_fifo_pop_i  ( reg2hw.err_code.req & ~reg2hw.err_code.req_is_wr ),
    .err_code_o      ( read_err_err       ),
    .err_addr_o      ( read_err_addr      ),
    .err_meta_o      ( read_err_meta      ),
    .err_fifo_overflow_o( read_err_overflow )
  );

endmodule
