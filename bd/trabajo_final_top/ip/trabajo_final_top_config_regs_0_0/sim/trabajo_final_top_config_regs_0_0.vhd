-- (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:module_ref:config_regs:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY trabajo_final_top_config_regs_0_0 IS
  PORT (
    btn_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    config_reg_0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    config_reg_1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    config_reg_2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    config_reg_3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    config_reg_4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    config_reg_5 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END trabajo_final_top_config_regs_0_0;

ARCHITECTURE trabajo_final_top_config_regs_0_0_arch OF trabajo_final_top_config_regs_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF trabajo_final_top_config_regs_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT config_regs IS
    PORT (
      btn_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      config_reg_0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      config_reg_1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      config_reg_2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      config_reg_3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      config_reg_4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      config_reg_5 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT config_regs;
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF trabajo_final_top_config_regs_0_0_arch: ARCHITECTURE IS "module_ref";
BEGIN
  U0 : config_regs
    PORT MAP (
      btn_i => btn_i,
      config_reg_0 => config_reg_0,
      config_reg_1 => config_reg_1,
      config_reg_2 => config_reg_2,
      config_reg_3 => config_reg_3,
      config_reg_4 => config_reg_4,
      config_reg_5 => config_reg_5
    );
END trabajo_final_top_config_regs_0_0_arch;
