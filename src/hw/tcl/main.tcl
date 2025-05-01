################################################################################
# Main tcl for the module
################################################################################

# ==============================================================================
proc init {} {
  ::fwfwk::printCBM "In ./hw/src/main.tcl init()..."



}

# ==============================================================================
proc setSources {} {
  ::fwfwk::printCBM "In ./hw/src/main.tcl setSources()..."

  variable Sources 

  
  lappend Sources {"../hdl/top.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/acmi_package.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/acmi_package.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/acmi_frontend.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/adc_gtp_link.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/adc_interface.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/adc_readout_test.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/backend_comm_wrapper.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/sfp_gtp.vhd" "VHDL 2008"}

lappend Sources {"../hdl/support/adc_gtp_clock_module.vhd" "VHDL 2008"}
lappend Sources {"../hdl/support/adc_gtp_common.vhd" "VHDL 2008"}
lappend Sources {"../hdl/support/adc_gtp_common_reset.vhd" "VHDL 2008"}
lappend Sources {"../hdl/support/adc_gtp_cpll_railing.vhd" "VHDL 2008"}
lappend Sources {"../hdl/support/adc_gtp_gt_usrclk_source.vhd" "VHDL 2008"}
lappend Sources {"../hdl/support/adc_gtp_support.vhd" "VHDL 2008"}
lappend Sources {"../hdl/support/gtwizard_0_clock_module.vhd" "VHDL 2008"}
lappend Sources {"../hdl/support/gtwizard_0_common.vhd" "VHDL 2008"}
lappend Sources {"../hdl/support/gtwizard_0_common_reset.vhd" "VHDL 2008"}
lappend Sources {"../hdl/support/gtwizard_0_cpll_railing.vhd" "VHDL 2008"}
lappend Sources {"../hdl/support/gtwizard_0_gt_usrclk_source.vhd" "VHDL 2008"}
lappend Sources {"../hdl/support/gtwizard_0_support.vhd" "VHDL 2008"}

lappend Sources {"../hdl/clk_wiz_0.xcix" }
lappend Sources {"../hdl/gtwizard_0.xcix" }
lappend Sources {"../hdl/adc_gtp/adc_gtp.xci"}
lappend Sources {"../hdl/adc_clk_wiz/adc_clk_wiz.xci"}

  lappend Sources {"../cstr/pins.xdc"  "XDC"} 
  lappend Sources {"../cstr/gtp.xdc"  "XDC"}     
  #lappend Sources {"../cstr/timing.xdc"  "XDC"} 
  #lappend Sources {"../cstr/debug.xdc"  "XDC"} 
  
  
}

# ==============================================================================
proc setAddressSpace {} {
  # ::fwfwk::printCBM "In ./hw/src/main.tcl setAddressSpace()..."
  #variable AddressSpace
  
  #addAddressSpace AddressSpace "pl_regs"   RDL  {} ../rdl/pl_regs.rdl

}


# ==============================================================================
proc doOnCreate {} {
  # variable Vhdl
  variable TclPath

      
  ::fwfwk::printCBM "In ./hw/src/main.tcl doOnCreate()"
  set_property part             xc7a200tfbg484-2             [current_project]
  set_property target_language  VHDL                         [current_project]
  set_property default_lib      xil_defaultlib               [current_project]
   
  
  #source ${TclPath}/system.tcl
  #source ${TclPath}/evr_gth.tcl
  #source ${TclPath}/gth_artix.tcl
  #source ${TclPath}/gth_freerun_clk.tcl
  #source ${TclPath}/wvfm_fifo.tcl
  

  addSources "Sources" 
  
  ::fwfwk::printCBM "TclPath = ${TclPath}"
  ::fwfwk::printCBM "SrcPath = ${::fwfwk::SrcPath}"
  
  #set_property used_in_synthesis false [get_files ${::fwfwk::SrcPath}/hw/hdl/top_tb.sv] 
  #set_property used_in_implementation false [get_files ${::fwfwk::SrcPath}/hw/hdl/top_tb.sv] 
  
  #open_wave_config "${::fwfwk::SrcPath}/hw/sim/top_tb_behav.wcfg"
  

  
  
}

# ==============================================================================
proc doOnBuild {} {
  ::fwfwk::printCBM "In ./hw/src/main.tcl doOnBuild()"



}


# ==============================================================================
proc setSim {} {
}
