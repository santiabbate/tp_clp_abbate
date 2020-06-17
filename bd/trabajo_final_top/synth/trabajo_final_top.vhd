--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
--Date        : Wed Jun 17 15:57:48 2020
--Host        : SANTI-ABBATE running 64-bit Ubuntu 18.04.4 LTS
--Command     : generate_target trabajo_final_top.bd
--Design      : trabajo_final_top
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity trabajo_final_top is
  port (
    btn_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
    clk_i : in STD_LOGIC;
    resetn_i : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of trabajo_final_top : entity is "trabajo_final_top,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=trabajo_final_top,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=4,numReposBlks=4,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=2,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of trabajo_final_top : entity is "trabajo_final_top.hwdef";
end trabajo_final_top;

architecture STRUCTURE of trabajo_final_top is
  component trabajo_final_top_ila_0_0 is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 71 downto 0 );
    probe1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe3 : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component trabajo_final_top_ila_0_0;
  component trabajo_final_top_xlconstant_6_0 is
  port (
    dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component trabajo_final_top_xlconstant_6_0;
  component trabajo_final_top_dds_modulator_0_0 is
  port (
    clk_i : in STD_LOGIC;
    resetn_i : in STD_LOGIC;
    dds_en_o : out STD_LOGIC;
    m_axis_modulation_tdata : out STD_LOGIC_VECTOR ( 71 downto 0 );
    m_axis_modulation_tvalid : out STD_LOGIC;
    m_axis_modulation_tready : in STD_LOGIC;
    config_reg_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    config_reg_1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    config_reg_2 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    config_reg_3 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    config_reg_4 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    config_reg_5 : in STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component trabajo_final_top_dds_modulator_0_0;
  component trabajo_final_top_config_regs_0_0 is
  port (
    btn_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
    config_reg_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    config_reg_1 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    config_reg_2 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    config_reg_3 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    config_reg_4 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    config_reg_5 : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component trabajo_final_top_config_regs_0_0;
  signal btn_i_1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal clk_i_1 : STD_LOGIC;
  signal config_regs_0_config_reg_0 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal config_regs_0_config_reg_1 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal config_regs_0_config_reg_2 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal config_regs_0_config_reg_3 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal config_regs_0_config_reg_4 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal config_regs_0_config_reg_5 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal dds_modulator_0_dds_en_o : STD_LOGIC;
  signal dds_modulator_0_m_axis_modulation_tdata : STD_LOGIC_VECTOR ( 71 downto 0 );
  signal dds_modulator_0_m_axis_modulation_tvalid : STD_LOGIC;
  signal resetn_i_0_1 : STD_LOGIC;
  signal xlconstant_6_dout : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk_i : signal is "xilinx.com:signal:clock:1.0 CLK.CLK_I CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk_i : signal is "XIL_INTERFACENAME CLK.CLK_I, CLK_DOMAIN trabajo_final_top_clk_i, FREQ_HZ 125000000, INSERT_VIP 0, PHASE 0.000";
begin
  btn_i_1(3 downto 0) <= btn_i(3 downto 0);
  clk_i_1 <= clk_i;
  resetn_i_0_1 <= resetn_i;
config_regs_0: component trabajo_final_top_config_regs_0_0
     port map (
      btn_i(3 downto 0) => btn_i_1(3 downto 0),
      config_reg_0(31 downto 0) => config_regs_0_config_reg_0(31 downto 0),
      config_reg_1(31 downto 0) => config_regs_0_config_reg_1(31 downto 0),
      config_reg_2(31 downto 0) => config_regs_0_config_reg_2(31 downto 0),
      config_reg_3(31 downto 0) => config_regs_0_config_reg_3(31 downto 0),
      config_reg_4(31 downto 0) => config_regs_0_config_reg_4(31 downto 0),
      config_reg_5(31 downto 0) => config_regs_0_config_reg_5(31 downto 0)
    );
dds_modulator_0: component trabajo_final_top_dds_modulator_0_0
     port map (
      clk_i => clk_i_1,
      config_reg_0(31 downto 0) => config_regs_0_config_reg_0(31 downto 0),
      config_reg_1(31 downto 0) => config_regs_0_config_reg_1(31 downto 0),
      config_reg_2(31 downto 0) => config_regs_0_config_reg_2(31 downto 0),
      config_reg_3(31 downto 0) => config_regs_0_config_reg_3(31 downto 0),
      config_reg_4(31 downto 0) => config_regs_0_config_reg_4(31 downto 0),
      config_reg_5(31 downto 0) => config_regs_0_config_reg_5(31 downto 0),
      dds_en_o => dds_modulator_0_dds_en_o,
      m_axis_modulation_tdata(71 downto 0) => dds_modulator_0_m_axis_modulation_tdata(71 downto 0),
      m_axis_modulation_tready => xlconstant_6_dout(0),
      m_axis_modulation_tvalid => dds_modulator_0_m_axis_modulation_tvalid,
      resetn_i => resetn_i_0_1
    );
ila_0: component trabajo_final_top_ila_0_0
     port map (
      clk => clk_i_1,
      probe0(71 downto 0) => dds_modulator_0_m_axis_modulation_tdata(71 downto 0),
      probe1(0) => dds_modulator_0_m_axis_modulation_tvalid,
      probe2(0) => dds_modulator_0_dds_en_o,
      probe3(0) => resetn_i_0_1
    );
xlconstant_6: component trabajo_final_top_xlconstant_6_0
     port map (
      dout(0) => xlconstant_6_dout(0)
    );
end STRUCTURE;
