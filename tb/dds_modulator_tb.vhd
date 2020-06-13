
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dds_modulator_tb is
end;

architecture dds_modulator_tb_arq of dds_modulator_tb is

	-- Constantes
	constant CLOCK_PERIOD: time := 8 ns;
	constant T_INITIAL_RESET: time := 20 * CLOCK_PERIOD;

	-- Declaracion del componente a probar
	component dds_modulator is
		generic(N : natural:=2);
		port(
			clk_i: in std_logic;
			resetn_i: in std_logic;
			dds_en_o: out std_logic;
	
			m_axis_modulation_tdata: out std_logic_vector(71 downto 0);
			m_axis_modulation_tvalid: out std_logic;
			m_axis_modulation_tready: in std_logic;
	
			config_reg_0: in std_logic_vector(31 downto 0);
			config_reg_1: in std_logic_vector(31 downto 0);
			config_reg_2: in std_logic_vector(31 downto 0);
			config_reg_3: in std_logic_vector(31 downto 0);
			config_reg_4: in std_logic_vector(31 downto 0);
			config_reg_5: in std_logic_vector(31 downto 0)
		);
	end component;

	-- Declaracion de las senales de prueba
	signal clk_i: std_logic := '1';
	signal resetn_i: std_logic := '0';
	signal dds_en_o: std_logic;

	signal m_axis_modulation_tdata: std_logic_vector(71 downto 0) := (others => '0');
	signal m_axis_modulation_tvalid: std_logic := '0';
	signal m_axis_modulation_tready: std_logic := '0';

	signal config_reg_0: std_logic_vector(31 downto 0) := (others => '0');
	signal config_reg_1: std_logic_vector(31 downto 0) := (others => '0');
	signal config_reg_2: std_logic_vector(31 downto 0) := (others => '0');
	signal config_reg_3: std_logic_vector(31 downto 0) := (others => '0');
	signal config_reg_4: std_logic_vector(31 downto 0) := (others => '0');
	signal config_reg_5: std_logic_vector(31 downto 0) := (others => '0');

	signal switches: std_logic_vector(3 downto 0);
	signal leds: std_logic_vector(3 downto 0);
	signal e_led: std_logic_vector(3 downto 0);
	
	-- Funcion para generar los valores de salida esperados en funcion de la entrada
	-- function expected_led(swt: std_logic_vector(3 downto 0)) return std_logic_vector is
	-- 	variable aux: std_logic_vector(3 downto 0);
	-- begin
	-- 	aux(0) := not swt(0);
	-- 	aux(1) := swt(1) and not swt(2);
	-- 	aux(3) := swt(2) and swt(3);
	-- 	aux(2) := aux(1) or aux(3);

	-- 	return aux;
	-- end function;
	
begin

	-- Instancia del componente a probar
	DUT: dds_modulator
		port map(
			clk_i => clk_i,
			resetn_i => resetn_i,
			dds_en_o => dds_en_o,
			m_axis_modulation_tdata => m_axis_modulation_tdata,
			m_axis_modulation_tvalid => m_axis_modulation_tvalid,
			m_axis_modulation_tready => m_axis_modulation_tready,	
			config_reg_0 => config_reg_0,
			config_reg_1 => config_reg_1,
			config_reg_2 => config_reg_2,
			config_reg_3 => config_reg_3,
			config_reg_4 => config_reg_4,
			config_reg_5 => config_reg_5
		);


	-- Generación de clock
	clock_gen : process
	begin
		clk_i <= '0';
		wait for CLOCK_PERIOD;
		loop
			clk_i <= '0';
			wait for CLOCK_PERIOD/2;
			clk_i <= '1';
			wait for CLOCK_PERIOD/2;
		end loop;
	end process clock_gen;

	-----------------------------------------------------------------------
  	-- Reset
  	-----------------------------------------------------------------------

	-- Disable the clock for 20 clock cycles starting in cycle 100.
	-- Keep the clock enable tied high for the rest of the test.
	resetn_gen : process
	begin
		resetn_i <= '0';
		-- Drive clock enable T_HOLD time after rising edge of clock
		wait until rising_edge(clk_i);
		wait for T_INITIAL_RESET;
		resetn_i <= '1';
		wait;
	end process resetn_gen;


	-- Generacion de las senales de prueba y verificacion

	-- process
	-- 	variable i: natural := 0;
	-- begin
	-- 	while (i < 255) loop
	-- 		wait for 50 ns;
	-- 		switches <= std_logic_vector(to_unsigned(i, 4));
	-- 		wait for 10 ns;
	-- 		e_led <= expected_led(switches);
	-- 		wait for 10 ns;
	-- 		if (leds = e_led) then
	-- 			report "La salida LED es correcta en " & time'image(now);
	-- 		else
	-- 			report "La salida LED es incorrecta en " & time'image(now) & ": esperado: " & integer'image(to_integer(unsigned(e_led))) & ", actual: " & integer'image(to_integer(unsigned(leds)));
	-- 		end if;
	-- 		i := i + 2;
	-- 	end loop;
	-- end process;
	
end;