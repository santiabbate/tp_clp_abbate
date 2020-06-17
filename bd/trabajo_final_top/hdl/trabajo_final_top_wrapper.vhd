--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
--Date        : Wed Jun 17 15:57:48 2020
--Host        : SANTI-ABBATE running 64-bit Ubuntu 18.04.4 LTS
--Command     : generate_target trabajo_final_top_wrapper.bd
--Design      : trabajo_final_top_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity trabajo_final_top_wrapper is
  port (
    btn_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
    clk_i : in STD_LOGIC;
    resetn_i : in STD_LOGIC
  );
end trabajo_final_top_wrapper;

architecture STRUCTURE of trabajo_final_top_wrapper is
  component trabajo_final_top is
  port (
    resetn_i : in STD_LOGIC;
    clk_i : in STD_LOGIC;
    btn_i : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  end component trabajo_final_top;
begin
trabajo_final_top_i: component trabajo_final_top
     port map (
      btn_i(3 downto 0) => btn_i(3 downto 0),
      clk_i => clk_i,
      resetn_i => resetn_i
    );
end STRUCTURE;
