// Copyright 2023 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Michael Rogenmoser <michaero@iis.ee.ethz.ch>

/// OBI wrapper for the bus error unit
module obi_err_unit_wrap #(
  parameter int unsigned AddrWidth       = 32,
  parameter int unsigned MetaDataWidth   = 1,
  parameter int unsigned ErrBits         = 1,
  parameter int unsigned NumOutstanding  = 2,
  parameter int unsigned NumStoredErrors = 1,
  parameter bit          DropOldest      = 1'b0,
  parameter type         apb_req_t       = logic,
  parameter type         apb_rsp_t       = logic
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 testmode_i,

  input  logic                 obi_req_i,
  input  logic                 obi_gnt_i,
  input  logic                 obi_rvalid_i,
  input  logic [AddrWidth-1:0] obi_addr_i,
  input  logic [  ErrBits-1:0] obi_err_i,
  input  logic [MetaDataWidth-1:0] obi_metadata_i,

  output logic                 err_irq_o,

  input  apb_req_t             apb_req_i,
  output apb_rsp_t             apb_rsp_o
);

  bus_err_unit #(
    .AddrWidth      (AddrWidth),
    .MetaDataWidth  (MetaDataWidth),
    .ErrBits        (ErrBits),
    .NumOutstanding (NumOutstanding),
    .NumStoredErrors(NumStoredErrors),
    .NumChannels    (1),
    .DropOldest     (DropOldest),
    .apb_req_t      (apb_req_t),
    .apb_rsp_t      (apb_rsp_t)
  ) i_err_unit (
    .clk_i,
    .rst_ni,
    .testmode_i,

    .req_hs_valid_i   ( obi_req_i & obi_gnt_i ),
    .req_addr_i       ( obi_addr_i            ),
    .req_meta_i       ( obi_metadata_i        ),
    .rsp_hs_valid_i   ( obi_rvalid_i          ),
    .rsp_burst_last_i ( obi_rvalid_i          ),
    .rsp_err_i        ( obi_err_i             ),

    .err_irq_o,

    .apb_req_i,
    .apb_rsp_o
  );

endmodule
