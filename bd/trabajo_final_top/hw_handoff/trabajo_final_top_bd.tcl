
################################################################
# This is a generated script based on design: trabajo_final_top
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source trabajo_final_top_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# config_regs, dds_modulator

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
   set_property BOARD_PART digilentinc.com:arty-z7-10:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name trabajo_final_top

# This script was generated for a remote BD. To create a non-remote design,
# change the variable <run_remote_bd_flow> to <0>.

set run_remote_bd_flow 1
if { $run_remote_bd_flow == 1 } {
  # Set the reference directory for source file relative paths (by default 
  # the value is script directory path)
  set origin_dir ./bd

  # Use origin directory path location variable, if specified in the tcl shell
  if { [info exists ::origin_dir_loc] } {
     set origin_dir $::origin_dir_loc
  }

  set str_bd_folder [file normalize ${origin_dir}]
  set str_bd_filepath ${str_bd_folder}/${design_name}/${design_name}.bd

  # Check if remote design exists on disk
  if { [file exists $str_bd_filepath ] == 1 } {
     catch {common::send_msg_id "BD_TCL-110" "ERROR" "The remote BD file path <$str_bd_filepath> already exists!"}
     common::send_msg_id "BD_TCL-008" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0>."
     common::send_msg_id "BD_TCL-009" "INFO" "Also make sure there is no design <$design_name> existing in your current project."

     return 1
  }

  # Check if design exists in memory
  set list_existing_designs [get_bd_designs -quiet $design_name]
  if { $list_existing_designs ne "" } {
     catch {common::send_msg_id "BD_TCL-111" "ERROR" "The design <$design_name> already exists in this project! Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_msg_id "BD_TCL-010" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Check if design exists on disk within project
  set list_existing_designs [get_files -quiet */${design_name}.bd]
  if { $list_existing_designs ne "" } {
     catch {common::send_msg_id "BD_TCL-112" "ERROR" "The design <$design_name> already exists in this project at location:
    $list_existing_designs"}
     catch {common::send_msg_id "BD_TCL-113" "ERROR" "Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_msg_id "BD_TCL-011" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Now can create the remote BD
  # NOTE - usage of <-dir> will create <$str_bd_folder/$design_name/$design_name.bd>
  create_bd_design -dir $str_bd_folder $design_name
} else {

  # Create regular design
  if { [catch {create_bd_design $design_name} errmsg] } {
     common::send_msg_id "BD_TCL-012" "INFO" "Please set a different value to variable <design_name>."

     return 1
  }
}

current_bd_design $design_name

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set btn_i [ create_bd_port -dir I -from 3 -to 0 btn_i ]
  set clk_i [ create_bd_port -dir I -type clk -freq_hz 125000000 clk_i ]
  set resetn_i [ create_bd_port -dir I resetn_i ]

  # Create instance: config_regs_0, and set properties
  set block_name config_regs
  set block_cell_name config_regs_0
  if { [catch {set config_regs_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $config_regs_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: dds_modulator_0, and set properties
  set block_name dds_modulator
  set block_cell_name dds_modulator_0
  if { [catch {set dds_modulator_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dds_modulator_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {16384} \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {4} \
   CONFIG.C_PROBE0_WIDTH {72} \
   CONFIG.C_SLOT_0_AXI_PROTOCOL {AXI4S} \
 ] $ila_0

  # Create instance: xlconstant_6, and set properties
  set xlconstant_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_6 ]

  # Create port connections
  connect_bd_net -net btn_i_1 [get_bd_ports btn_i] [get_bd_pins config_regs_0/btn_i]
  connect_bd_net -net clk_i_1 [get_bd_ports clk_i] [get_bd_pins dds_modulator_0/clk_i] [get_bd_pins ila_0/clk]
  connect_bd_net -net config_regs_0_config_reg_0 [get_bd_pins config_regs_0/config_reg_0] [get_bd_pins dds_modulator_0/config_reg_0]
  connect_bd_net -net config_regs_0_config_reg_1 [get_bd_pins config_regs_0/config_reg_1] [get_bd_pins dds_modulator_0/config_reg_1]
  connect_bd_net -net config_regs_0_config_reg_2 [get_bd_pins config_regs_0/config_reg_2] [get_bd_pins dds_modulator_0/config_reg_2]
  connect_bd_net -net config_regs_0_config_reg_3 [get_bd_pins config_regs_0/config_reg_3] [get_bd_pins dds_modulator_0/config_reg_3]
  connect_bd_net -net config_regs_0_config_reg_4 [get_bd_pins config_regs_0/config_reg_4] [get_bd_pins dds_modulator_0/config_reg_4]
  connect_bd_net -net config_regs_0_config_reg_5 [get_bd_pins config_regs_0/config_reg_5] [get_bd_pins dds_modulator_0/config_reg_5]
  connect_bd_net -net dds_modulator_0_dds_en_o [get_bd_pins dds_modulator_0/dds_en_o] [get_bd_pins ila_0/probe2]
  connect_bd_net -net dds_modulator_0_m_axis_modulation_tdata [get_bd_pins dds_modulator_0/m_axis_modulation_tdata] [get_bd_pins ila_0/probe0]
  connect_bd_net -net dds_modulator_0_m_axis_modulation_tvalid [get_bd_pins dds_modulator_0/m_axis_modulation_tvalid] [get_bd_pins ila_0/probe1]
  connect_bd_net -net resetn_i_0_1 [get_bd_ports resetn_i] [get_bd_pins dds_modulator_0/resetn_i] [get_bd_pins ila_0/probe3]
  connect_bd_net -net xlconstant_6_dout [get_bd_pins dds_modulator_0/m_axis_modulation_tready] [get_bd_pins xlconstant_6/dout]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


