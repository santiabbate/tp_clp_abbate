library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package dds_modulator_pkg is

    constant ENABLE_BIT: integer := 0;
    constant MODE_BIT: integer := 0;
    constant MODE_PULSED: std_logic := '0';
    constant MODE_CONTINUOUS: std_logic := '1';
    constant MODULATION_TYPE_BIT: integer := 2;
    
    constant FREQ_MODULATION: integer := 1;
    constant PHASE_MODULATION: integer := 0;

    constant S_BITS: natural := 3;
    
    constant PERIOD_COUNTER_BITS: natural := 15;
    constant PINC_BITS: natural := 30;

    constant PHASE_OFFSET_180: std_logic_vector(PINC_BITS-1 downto 0) := std_logic_vector( to_unsigned(536870911, PINC_BITS) );

    constant FCLK_MHZ: integer := 125;

    constant BARKER_2: std_logic_vector(12 downto 0) := "0000000000010";
    constant BARKER_3: std_logic_vector(12 downto 0) := "0000000000110";
    constant BARKER_4: std_logic_vector(12 downto 0) := "0000000001011";
    constant BARKER_5: std_logic_vector(12 downto 0) := "0000000011101";
    constant BARKER_7: std_logic_vector(12 downto 0) := "0000001110010";
    constant BARKER_11: std_logic_vector(12 downto 0) := "0011100010010";
    constant BARKER_13: std_logic_vector(12 downto 0) := "1111100110101";

end package;