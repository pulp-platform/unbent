# Copyright 2023 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

BENDER ?= bender

PEAKRDL ?= peakrdl

.PHONY: gen_regs
gen_regs: src/bus_err_unit_reg_pkg.sv src/bus_err_unit_reg_top.sv
gen_regs: doc/bus_err_unit_reg.md
gen_regs: driver/bus_err_unit_reg.h driver/bus_err_unit_reg_addrmap.h
gen_regs: doc/axi_bus_err_unit_reg.md
gen_regs: driver/axi_bus_err_unit_reg.h driver/axi_bus_err_unit_reg_addrmap.h

src/bus_err_unit_reg_pkg.sv src/bus_err_unit_reg_top.sv: rdl/bus_err_unit.rdl
	$(PEAKRDL) regblock $< -o src --cpuif apb4-flat --default-reset arst_n --module-name bus_err_unit_reg_top --package-name bus_err_unit_reg_pkg

doc/bus_err_unit_reg.md: rdl/bus_err_unit.rdl
	$(PEAKRDL) markdown $< -o $@

driver/bus_err_unit_reg.h: rdl/bus_err_unit.rdl
	$(PEAKRDL) c-header $< -o $@

driver/bus_err_unit_reg_addrmap.h: rdl/bus_err_unit.rdl
	$(PEAKRDL) raw-header $< -o $@ --format c

doc/axi_bus_err_unit_reg.md: rdl/axi_bus_err_unit.rdl rdl/bus_err_unit.rdl
	$(PEAKRDL) markdown $< -o $@ -I rdl

driver/axi_bus_err_unit_reg.h: rdl/axi_bus_err_unit.rdl rdl/bus_err_unit.rdl
	$(PEAKRDL) c-header $< -o $@ -I rdl

driver/axi_bus_err_unit_reg_addrmap.h: rdl/axi_bus_err_unit.rdl rdl/bus_err_unit.rdl
	$(PEAKRDL) raw-header $< -o $@ --format c -I rdl
