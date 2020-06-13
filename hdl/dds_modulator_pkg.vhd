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

    
end package;