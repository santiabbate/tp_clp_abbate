
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

library dds_modulator;
use dds_modulator.dds_modulator_pkg.all;

entity dds_modulator_tb is
end;

architecture dds_modulator_tb_arq of dds_modulator_tb is

	-- Constantes
	constant CLOCK_PERIOD: time := 8 ns;
	constant T_INITIAL_RESET: time := 20 * CLOCK_PERIOD;

	constant CONT_NO_MOD:     std_logic_vector(2 downto 0) := "001";    
	constant CONT_MOD_FREC:   std_logic_vector(2 downto 0) := "111";
	constant CONT_MOD_PHASE:  std_logic_vector(2 downto 0) := "011";
	constant PULS_NO_MOD:     std_logic_vector(2 downto 0) := "000";
	constant PULS_MOD_FREC:   std_logic_vector(2 downto 0) := "110";
	constant PULS_MOD_PHASE:  std_logic_vector(2 downto 0) := "010";

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

	-- DDS para pruebas
	component dds_compiler_dds_compiler_0_0 IS
	PORT (
	  aclk : IN STD_LOGIC;
	  aclken : IN STD_LOGIC;
	  aresetn : IN STD_LOGIC;
	  s_axis_phase_tvalid : IN STD_LOGIC;
	  s_axis_phase_tready : OUT STD_LOGIC;
	  s_axis_phase_tdata : IN STD_LOGIC_VECTOR(71 DOWNTO 0);
	  m_axis_data_tvalid : OUT STD_LOGIC;
	  m_axis_data_tready : IN STD_LOGIC;
	  m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
  	end component;

	-- Señales DDS 
	signal m_axis_data_tvalid : STD_LOGIC;
	signal m_axis_data_tready : STD_LOGIC;
	signal m_axis_data_tdata :  STD_LOGIC_VECTOR(31 DOWNTO 0);


	-- Declaracion de las senales de prueba
	signal clk_i: std_logic := '1';
	signal resetn_i: std_logic := '0';
	signal dds_en_o: std_logic;

	signal m_axis_modulation_tdata: std_logic_vector(71 downto 0) := (others => '0');
	signal m_axis_modulation_tvalid: std_logic := '0';
	signal m_axis_modulation_tready: std_logic := '1';

	signal config_reg_0: std_logic_vector(31 downto 0) := (others => '0');
	signal config_reg_1: std_logic_vector(31 downto 0) := (others => '0');
	signal config_reg_2: std_logic_vector(31 downto 0) := (others => '0');
	signal config_reg_3: std_logic_vector(31 downto 0) := (others => '0');
	signal config_reg_4: std_logic_vector(31 downto 0) := (others => '0');
	signal config_reg_5: std_logic_vector(31 downto 0) := (others => '0');
	
	----------------------------------------------------------
	-- Funciones y procedimientos
	----------------------------------------------------------
	-- Habilitar / Deshabilitar modulador
	procedure modulator_enable(value: in std_logic;
							   out_0: out std_logic_vector(31 downto 0)) is
	begin
		out_0(ENABLE_BIT) := value;
	end procedure;

	-- Setear frecuencia en modo continuo (f en MHz)
	procedure modulator_set_cont_frec(fout_MHz: in integer;
							   out_0: out std_logic_vector(31 downto 0)) is
		variable aux: integer;
	begin
		-- out_0 := (fout_MHz*(2**30))/125 ;
		aux := (fout_MHz*(2**PINC_BITS))/FCLK_MHZ;
		out_0 := std_logic_vector(to_unsigned(aux,32));
	end procedure;
	
	-- Setear modulación en frecuencia
	procedure modulator_set_frec_mod(f_low_MHz: in integer;
									 f_high_MHz: in integer;
									 period_us: in integer;
									 pinc_low: out std_logic_vector(31 downto 0);
									 pinc_high: out std_logic_vector(31 downto 0);
									 delta_pinc: out std_logic_vector(31 downto 0)) is
		variable aux1: integer;
		variable aux2: integer;
		variable aux3: integer;
	begin
		aux1 := f_low_MHz * ((2 ** PINC_BITS) / FCLK_MHZ);
        aux2 := f_high_MHz * ((2 ** PINC_BITS) / FCLK_MHZ);
        aux3 := (aux2 - aux1) / (period_us * FCLK_MHZ);

		pinc_low := std_logic_vector(to_unsigned(aux1,32));
        pinc_high := std_logic_vector(to_unsigned(aux2,32));
		delta_pinc := std_logic_vector(to_unsigned(aux3,32));
	end procedure;

	-- Setear modulación en fase
	procedure modulator_set_phase_mod(barker_code_num: in integer;
									  subpulse_us: in integer;
									  fout_MHz: in integer;
									  pinc: out std_logic_vector(31 downto 0);
									  barker_subpulse_length: out std_logic_vector(31 downto 0);
									  barker_sequence: out std_logic_vector(31 downto 0)) is
		variable aux1: integer;
		variable aux2: integer;
		variable aux3: integer;
		variable barker_code: std_logic_vector(12 downto 0);								
	begin
		-- Frecuencia continua
		aux1 := fout_MHz * ((2 ** PINC_BITS) / FCLK_MHZ) ;
		-- Ancho de cada subpulso
		aux2 := subpulse_us * FCLK_MHZ;

		case( barker_code_num ) is
		
			when 2 => barker_code := BARKER_2;
			when 3 => barker_code := BARKER_3;
			when 4 => barker_code := BARKER_4;
			when 5 => barker_code := BARKER_5;
			when 7 => barker_code := BARKER_7;
			when 11 => barker_code := BARKER_11;
			when 13 => barker_code := BARKER_13;
			when others => barker_code := "0000000000000";
		
		end case ;

		pinc := std_logic_vector(to_unsigned(aux1,32));
		barker_subpulse_length := std_logic_vector(to_unsigned(aux2,32));
		barker_sequence := (others => '0');
		barker_sequence(31 downto 28) := std_logic_vector(to_unsigned(barker_code_num,4));
		barker_sequence(12 downto 0) := barker_code;
	end procedure;
	
	-- Setear el período y anchu de pulso para modo pulsado
	procedure modulator_set_period(pulse_us: in integer;
								   period_us: in integer;
								   out_2: out std_logic_vector(31 downto 0)) is
		variable aux1: integer;
		variable aux2: integer;
	begin
		aux1 := pulse_us * FCLK_MHZ;
		aux2 := period_us * FCLK_MHZ;

		out_2 := (others => '0');
		out_2(30 downto 16) := std_logic_vector(to_unsigned(aux1,15));
		out_2(14 downto 0) := std_logic_vector(to_unsigned(aux2,15));
	end procedure;
	
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

	-- Instancia DDS
	DDS: dds_compiler_dds_compiler_0_0
		port map (
			aclk => clk_i,
			aclken => dds_en_o,
			aresetn => resetn_i,
			s_axis_phase_tvalid => m_axis_modulation_tvalid,
			s_axis_phase_tready => m_axis_modulation_tready,
			s_axis_phase_tdata => m_axis_modulation_tdata,
			m_axis_data_tvalid => m_axis_data_tvalid,
			m_axis_data_tready => '1',
			m_axis_data_tdata => m_axis_data_tdata
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
	-- resetn_gen : process
	-- begin
	-- 	resetn_i <= '0';
	-- 	-- Drive clock enable T_HOLD time after rising edge of clock
	-- 	wait until rising_edge(clk_i);
	-- 	wait for T_INITIAL_RESET;
	-- 	resetn_i <= '1';
	-- 	wait;
	-- end process resetn_gen;

	-----------------------------------------------------------------------
  	-- Axi-Stream tready
  	-----------------------------------------------------------------------
	
	-----------------------------------------------------------------------
  	-- Secuencia del test
  	-----------------------------------------------------------------------

	process
	variable proc_out_0: std_logic_vector(31 downto 0) := (others => '0');
	variable proc_out_1: std_logic_vector(31 downto 0) := (others => '0');
	variable proc_out_2: std_logic_vector(31 downto 0) := (others => '0');
	variable proc_out_3: std_logic_vector(31 downto 0) := (others => '0');
	variable proc_out_4: std_logic_vector(31 downto 0) := (others => '0');
	variable proc_out_5: std_logic_vector(31 downto 0) := (others => '0');
	variable pulse_width: integer;
	variable barkerseq: integer;
	variable seqwidth: integer;

	begin
			-- wait until rising_edge(resetn_i); -- Espero a salir de reset
			resetn_i <= '0';
			wait until rising_edge(clk_i); -- Espero a salir de reset
			wait for T_INITIAL_RESET;
			resetn_i <= '1';
			---------------------------------
			-- TEST: 1) Frecuencia continua
			---------------------------------
			-- Configuro el modo
			config_reg_1(2 downto 0) <= CONT_NO_MOD;
			-- Configuro una frecuencia de 1MHz
			modulator_set_cont_frec(1, proc_out_3);
			config_reg_3 <= proc_out_3;
			-- Habilito el modulador
			modulator_enable('1', proc_out_0);
			config_reg_0 <= proc_out_0;
			wait for 20 us;
			-- Cambio de frecuencia (10 MHz)
			modulator_set_cont_frec(10, proc_out_0);
			config_reg_3 <= proc_out_0;
			wait for 20 us;
			-- Deshabilito el modulador
			modulator_enable('0', proc_out_0);
			config_reg_0 <= proc_out_0;
			---------------------------------
			-- END TEST: Frecuencia continua
			---------------------------------
			resetn_i <= '0';
			wait for 10 us;
			resetn_i <= '1';
			-------------------------------------------------
			-- TEST: 2) Modo continuo modulado en frecuencia
			-------------------------------------------------
			-- Configuro el modo
			config_reg_1(2 downto 0) <= CONT_MOD_FREC;
			modulator_set_frec_mod(0, 3, 50, proc_out_3, proc_out_4, proc_out_5);
			config_reg_3 <= proc_out_3;
			config_reg_4 <= proc_out_4;
			config_reg_5 <= proc_out_5;
			-- Habilito el modulador
			modulator_enable('1', proc_out_0);
			config_reg_0 <= proc_out_0;
			wait for 200 us;
			-- Deshabilito el modulador
			modulator_enable('0', proc_out_0);
			config_reg_0 <= proc_out_0;
			--------------------------------------------------
			-- END TEST: Modo continuo modulado en frecuencia
			--------------------------------------------------	
			resetn_i <= '0';
			wait for 10 us;
			resetn_i <= '1';
			----------------------------------------------
			-- TEST: 3) Modo continuo modulado en fase
			----------------------------------------------
			-- Configuro el modo
			config_reg_1(2 downto 0) <= CONT_MOD_PHASE;
			modulator_set_phase_mod(13, 2, 1, proc_out_3, proc_out_4, proc_out_5);
			config_reg_3 <= proc_out_3;
			config_reg_4 <= proc_out_4;
			config_reg_5 <= proc_out_5;
			-- Habilito el modulador
			modulator_enable('1', proc_out_0);
			config_reg_0 <= proc_out_0;
			wait for 200 us;
			-- Deshabilito el modulador
			modulator_enable('0', proc_out_0);
			config_reg_0 <= proc_out_0;
			----------------------------------------------
			-- END TEST: Modo continuo modulado en fase
			----------------------------------------------
			resetn_i <= '0';
			wait for 10 us;
			resetn_i <= '1';
			----------------------------------------------
			-- TEST: 4) Modo pulsado sin modulación
			----------------------------------------------
			-- Configuro el modo
			config_reg_1(2 downto 0) <= PULS_NO_MOD;
			-- Ancho de pulso de 50 us, período de 200 us
			modulator_set_period(5,15, proc_out_2);
			config_reg_2 <= proc_out_2;
			modulator_set_cont_frec(1, proc_out_3);
			config_reg_3 <= proc_out_3;
			-- Habilito el modulador
			modulator_enable('1', proc_out_0);
			config_reg_0 <= proc_out_0;
			wait for 650 us;
			-- Deshabilito el modulador
			modulator_enable('0', proc_out_0);
			config_reg_0 <= proc_out_0;
			----------------------------------------------
			-- END TEST: Modo pulsado sin modulación
			----------------------------------------------
			resetn_i <= '0';
			wait for 10 us;
			resetn_i <= '1';
			-------------------------------------------------
			-- TEST: 5) Modo pulsado modulado en frecuencia
			-------------------------------------------------
			-- Configuro el modo
			config_reg_1(2 downto 0) <= PULS_MOD_FREC;
			-- Ancho de pulso de 5us, período de 20us
			pulse_width := 5;
			modulator_set_period(pulse_width, 15, proc_out_2);
			config_reg_2 <= proc_out_2;
			-- Barrido en frecuencia de 0 a 20 MHz, en el ancho de pulso configurado
			modulator_set_frec_mod(0, 5, pulse_width, proc_out_3, proc_out_4, proc_out_5);
			config_reg_3 <= proc_out_3;
			config_reg_4 <= proc_out_4;
			config_reg_5 <= proc_out_5;
			-- Habilito el modulador
			modulator_enable('1', proc_out_0);
			config_reg_0 <= proc_out_0;
			wait for 450 us;
			-- Deshabilito el modulador
			modulator_enable('0', proc_out_0);
			config_reg_0 <= proc_out_0;
			-------------------------------------------------
			-- END TEST: Modo pulsado modulado en frecuencia
			-------------------------------------------------
			resetn_i <= '0';
			wait for 10 us;
			resetn_i <= '1';
			-------------------------------------------
			-- TEST: 6) Modo pulsado modulado en fase
			-------------------------------------------
			-- Configuro el modo
			config_reg_1(2 downto 0) <= PULS_MOD_PHASE;
			-- Parámetros de la modulación
			barkerseq := 5;
			seqwidth := 2;
			modulator_set_period(barkerseq * seqwidth, barkerseq * seqwidth + 20, proc_out_2);
			config_reg_2 <= proc_out_2;
			-- Código Barker: 13, Ancho de c/subpulso: 5us, Frecuencia: 3MHz
			modulator_set_phase_mod(barkerseq, seqwidth, 1, proc_out_3, proc_out_4, proc_out_5);
			config_reg_3 <= proc_out_3;
			config_reg_4 <= proc_out_4;
			config_reg_5 <= proc_out_5;
			-- Habilito el modulador
			modulator_enable('1', proc_out_0);
			config_reg_0 <= proc_out_0;
			wait for 450 us;
			-- Deshabilito el modulador
			modulator_enable('0', proc_out_0);
			config_reg_0 <= proc_out_0;
			-------------------------------------------
			-- END TEST: Modo pulsado modulado en fase
			-------------------------------------------
			wait;
	end process;

	
end;