library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity config_regs is
    port(
        btn_i: in std_logic_vector(3 downto 0);

        config_reg_0: out std_logic_vector(31 downto 0);
        config_reg_1: out std_logic_vector(31 downto 0);
        config_reg_2: out std_logic_vector(31 downto 0);
        config_reg_3: out std_logic_vector(31 downto 0);
        config_reg_4: out std_logic_vector(31 downto 0);
        config_reg_5: out std_logic_vector(31 downto 0)
    );
end;

architecture arch of config_regs is

begin
    process(btn_i)
    begin
        case( btn_i ) is

            when "0001" => 
                -- Modo continuo sin modulación, frecuencia: 1 MHz.
                config_reg_0 <= X"00000001";
                config_reg_1 <= X"00000001";
                config_reg_2 <= (others => '0');
                config_reg_3 <= X"0083126E";
                config_reg_4 <= (others => '0');
                config_reg_5 <= (others => '0');
            
            when "0010" =>
                -- Modo continuo modulado en frecuencia.
                -- Frec: 1 MHz a 10 MHz.
                -- Duración: 10 us.
                config_reg_0 <= X"00000001";
                config_reg_1 <= X"00000007";
                config_reg_2 <= (others => '0');
                config_reg_3 <= X"0083126E";
                config_reg_4 <= X"051EB851";
                config_reg_5 <= X"0000F197";
            
            when "0100" =>
                -- Modo continuo modulado en fase
                -- Código Barker: 13
                -- Ancho de subpulso: 2 us.
                -- Frec: 1 MHz.
                config_reg_0 <= X"00000001";
                config_reg_1 <= X"00000003";
                config_reg_2 <= (others => '0');
                config_reg_3 <= X"0083126E";
                config_reg_4 <= X"000000FA";
                config_reg_5 <= X"D0001F35";
            
            when "1000" =>
                -- Modo pulsado sin modulación
                -- Frec: 1MHz.
                -- Período: 16 us.
                -- Ancho de pulso: 5 us.
                config_reg_0 <= X"00000001";
                config_reg_1 <= X"00000006";
                config_reg_2 <= X"027107D0";
                config_reg_3 <= X"0083126E";
                config_reg_4 <= (others => '0');
                config_reg_5 <= (others => '0');
            when others =>
                config_reg_0 <= (others => '0');
                config_reg_1 <= (others => '0');
                config_reg_2 <= (others => '0');
                config_reg_3 <= (others => '0');
                config_reg_4 <= (others => '0');
                config_reg_5 <= (others => '0');
        end case ;
    end process;

end arch;