library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library dds_modulator;
use dds_modulator.dds_modulator_pkg.all;

entity dds_modulator is
    generic(N : natural := 2);
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
end;

architecture dds_modulator_arq of dds_modulator is
    
    -- Config register 0 signals
    signal modulator_en: std_logic; -- Enable global

    -- Config register 1 signals
    signal mode: std_logic;                                 -- Modo Continuo o Pulsado
    signal modulation_type: std_logic;                      -- Modulación en frecuencia o en fase
    signal state_bits: std_logic_vector(S_BITS-1 downto 0); -- Bits de estado de entrada (Combinación de modo, enable de modulación y tipo de modulación)

    -- Config register 2 signals
    signal period: unsigned(PERIOD_COUNTER_BITS-1 downto 0);-- Período para el modo pulsado
    signal tau: unsigned(PERIOD_COUNTER_BITS-1 downto 0);   -- Ancho de pulso para el modo pulsado

    -- Config register 3 signals
    signal pinc: std_logic_vector(PINC_BITS-1 downto 0);    -- Incremento de fase (Seteo de frecuencia de salida, en modo continuo o modulado en fase)
    signal pinc_low: unsigned(PINC_BITS-1 downto 0);        -- Fase inicial (Frecuencia de salida inicial) en modo modulado en frecuencia

    -- Config register 4 signals
    signal barker_subpulse_length: unsigned(PINC_BITS-1 downto 0); -- Ancho de cada subpulso del código barker, en modulación en fase
    signal pinc_high: unsigned(PINC_BITS-1 downto 0);              -- Fase final (Frecuencia de salida final) en modo modulado en frecuencia
    
    -- Config register 5 signals
    signal delta_pinc: std_logic_vector(PINC_BITS-1 downto 0);  -- Pendiente de la modulación lineal en frecuencia         

    signal barker_seq_num: unsigned(3 downto 0);                -- Valor numérico de secuencia barker cargada (2,3,4,5,7,11,13)
    signal barker_sequence: std_logic_vector(12 downto 0);      -- Secuencia barker a generar en modulación en fase

    -- Output signal constructs
    signal tdata_pinc: std_logic_vector(PINC_BITS-1 downto 0);
    signal tdata_pinc_o: std_logic_vector(PINC_BITS-1 downto 0);
    signal tdata_offset: std_logic_vector(PINC_BITS-1 downto 0);
    signal tvalid: std_logic;
    
    -- Period counter signals for pulsed mode
    --    ____                   ____   
    -- __|    |_________________|    |__
    --        ^                 ^       
    --     midcount            stop     

    signal period_counter_reg: unsigned(PERIOD_COUNTER_BITS-1 downto 0);
    signal period_counter_stop, pulse_length: unsigned(PERIOD_COUNTER_BITS-1 downto 0);
    signal period_counter_en: std_logic;
    signal pulse_timeout_n: std_logic;

    signal resync: std_logic;

    -- Modulation counter signals for frequency modulated mode
    -- and phase modulation mode (counts length of barker
    -- code subpulses)

    signal modulation_counter_reg, modulation_counter_next, modulation_counter_start, modulation_counter_stop: unsigned(PINC_BITS-1 downto 0);
    signal modulation_counter_en: std_logic;
    signal modulation_counter_counting_subpulse_length: std_logic;     -- Am I counting subpulse length? flag
 
    signal modulation_counter_expired: std_logic;

    -- Barker subpulse counter for phase modulated mode
    
    signal barker_subpulse_counter_reg, barker_subpulse_counter_next: unsigned(3 downto 0);
    signal barker_subpulse_counter_en: std_logic;
    signal barker_phase: std_logic_vector(PINC_BITS-1 downto 0);


begin
    
    -- Internal signals from config registers
    modulator_en <= config_reg_0(ENABLE_BIT);
    
    mode <= config_reg_1(MODE_BIT);
    state_bits <= config_reg_1(S_BITS-1 downto 0);

    period <= unsigned(config_reg_2(PERIOD_COUNTER_BITS-1 downto 0));
    tau <= unsigned(config_reg_2(PERIOD_COUNTER_BITS-1+16 downto 16));

    pinc <= config_reg_3(PINC_BITS-1 downto 0);
    pinc_low <= unsigned(config_reg_3(PINC_BITS-1 downto 0));

    barker_subpulse_length <= unsigned(config_reg_4(PINC_BITS-1 downto 0));
    pinc_high <= unsigned(config_reg_4(PINC_BITS-1 downto 0));

    delta_pinc <= config_reg_5(PINC_BITS-1 downto 0);
    barker_seq_num <= unsigned(config_reg_5(31 downto 28));
    barker_sequence <= config_reg_5(12 downto 0);


    decode_state: process(state_bits, pinc, pinc_low, pinc_high, modulation_counter_reg, barker_subpulse_length, barker_phase, period, pulse_timeout_n)
    begin
        -- Valores por defecto
        modulation_counter_en <= '0';
        modulation_counter_start <= (others => '0');
        modulation_counter_stop <= (others => '0');
        modulation_counter_counting_subpulse_length <= '0';
        barker_subpulse_counter_en <= '0';
        period_counter_en <= '0';
        period_counter_stop <= (others => '0');
        pulse_length <= (others => '0');

        tdata_offset <= (others => '0');
        tdata_pinc <= (others => '0');
        
        tvalid <= '0';

        case  state_bits is
            -- Modo continuo sin modulación
            when "001" | "101" =>
                tdata_pinc <= pinc;
                tvalid <= '1';

            -- Modo continuo modulado en frecuencia
            when "111" =>
                modulation_counter_en  <= '1';
                modulation_counter_start <= pinc_low;
                modulation_counter_stop <= pinc_high;

                tdata_pinc <= std_logic_vector(modulation_counter_reg);
                tvalid <= '1';

            -- Modo continuo modulado en fase
            when "011" =>
                modulation_counter_en <= '1';
                modulation_counter_start <= (others => '0');
                modulation_counter_stop <= barker_subpulse_length;
                modulation_counter_counting_subpulse_length <= '1';
                
                barker_subpulse_counter_en <= '1';

                -- tdata_offset <= (others => '0') when (barker_sequence(to_integer(unsigned(barker_subpulse_counter_reg))) = '1') else PHASE_OFFSET_180;
                tdata_offset <= barker_phase;
                tdata_pinc <= pinc;
                tvalid <= '1';

            -- Modo pulsado sin modulación
            when "000" | "100" =>
                period_counter_en <= '1';
                period_counter_stop <= period;
                pulse_length <= tau;

                tdata_pinc <= pinc;
                tvalid <= '1';

            -- Modo pulsado modulado en frecuencia    
            when "110" =>
                period_counter_en <= '1';
                period_counter_stop <= period;
                pulse_length <= tau;
                
                modulation_counter_en <= pulse_timeout_n;
                modulation_counter_start <= pinc_low;
                modulation_counter_stop <= pinc_high;

                tdata_pinc <= std_logic_vector(modulation_counter_reg);
                tvalid <= '1';

            -- Modo pulsado modulado en fase
            when "010" =>
                modulation_counter_en <= pulse_timeout_n;
                modulation_counter_start <= (others => '0');
                modulation_counter_stop <= barker_subpulse_length;
                modulation_counter_counting_subpulse_length <= '1';
                
                barker_subpulse_counter_en <= pulse_timeout_n;

                period_counter_en <= '1';
                period_counter_stop <= period;
                pulse_length <= tau;
                
                -- tdata_offset <= (others => '0') when (barker_sequence(to_integer(unsigned(barker_subpulse_counter_reg))) = '1') else PHASE_OFFSET_180;
                tdata_offset <= barker_phase;
                tdata_pinc <= pinc;
                tvalid <= '1';

            when others =>
               -- Valores por defecto
                modulation_counter_en <= '0';
                modulation_counter_start <= (others => '0');
                modulation_counter_stop <= (others => '0');
                modulation_counter_counting_subpulse_length <= '0';
                barker_subpulse_counter_en <= '0';
                period_counter_en <= '0';
                period_counter_stop <= (others => '0');
                pulse_length <= (others => '0');

                tdata_offset <= (others => '0');
                tdata_pinc <= (others => '0');
                
                tvalid <= '0';
        end case;
    end process;


    ----------------------------------------------------------------------------------------
    -- Contador para el período de los pulsos
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if resetn_i = '0' then
                period_counter_reg <= (others => '0');
            else
                if (modulator_en and period_counter_en) = '1' then
                    -- Vuelvo a cero en cuenta máxima
                    if period_counter_reg = period_counter_stop then
                        period_counter_reg <= (others => '0');
                    else
                    --Incremento en uno
                        period_counter_reg <= period_counter_reg + 1;
                    end if;
                else
                    period_counter_reg <= (others => '0');
                end if;
            end if;

            -- Este tipo de sentencia VHDL (2008) no simula en Vivado
            -- period_counter_reg <= (others => '0') when resetn_i = '0' else
            --                       period_counter_reg + 1 when (modulator_en and period_counter_en) = '1' else
            --                       period_counter_reg;
        end if;
    end process;
    
    -- Registramos si se llegó al ancho de un pulso (lógica inversa)
    -- En modo coninuo siempre es '1'
    -- En modo pulsado, hace assert a '0' cuando hay un fin de pulso

    process(mode, period_counter_reg, pulse_length)
    begin
        if mode = MODE_CONTINUOUS then
            pulse_timeout_n <= '1';
        else
            if period_counter_reg < pulse_length then
                pulse_timeout_n <= '1';
            else
                pulse_timeout_n <= '0';
            end if;
        end if ;
    end process;

    -- pulse_timeout_n <= '1' when (mode = MODE_CONTINUOUS) else
    --                    '1' when (period_counter_reg < unsigned(pulse_length)) else
    --                    '0';

    ----------------------------------------------------------------------------------------                   
    -- Contador para la modulación en frecuencia y el ancho de los subpulsos de modulación en fase
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if resetn_i = '0' then
                modulation_counter_reg <= modulation_counter_start;
            else
                modulation_counter_reg <= modulation_counter_next;
            end if;
            
            -- Este tipo de sentencia VHDL (2008) no simula en Vivado
            -- modulation_counter_reg <= modulation_counter_start when resetn_i = '0' else
            --                           modulation_counter_next;
        end if;
    end process;

    process(
        modulator_en,
        modulation_counter_en,
        modulation_counter_reg,
        modulation_counter_stop
    )
    begin
        modulation_counter_expired <= '0';
        if modulator_en = '1' and modulation_counter_en = '1' then
            if modulation_counter_reg >= modulation_counter_stop then
                modulation_counter_next <= modulation_counter_start;
                modulation_counter_expired <= '1';
            else
                -- El contador se incrementa en 1 si estamos contando el ancho de subpulsos de modulación en fase,
                -- y se incrementa en delta_pinc para modular en frecuencia el DDS con una rampa.
                if modulation_counter_counting_subpulse_length = '1' then
                    modulation_counter_next <= modulation_counter_reg + 1;
                else
                    modulation_counter_next <= modulation_counter_reg + unsigned(delta_pinc);
                end if ;

                -- Este tipo de sentencia VHDL (2008) no simula en Vivado
                -- modulation_counter_next <= modulation_counter_reg + 1 when modulation_counter_counting_subpulse_length else
                --                            modulation_counter_reg + unsigned(delta_pinc);
            end if ; 
        else
            modulation_counter_next <= modulation_counter_start;     
        end if ;
    end process;

    ----------------------------------------------------------------------------------------
    -- Contador de subpulsos Barker
    -- Me indica qué pulso de la secuencia es el actual para aplicar el cambio de fase
    process( clk_i )
    begin
        if rising_edge(clk_i) then
            if resetn_i = '0' then
                barker_subpulse_counter_reg <= (others => '0');
            elsif barker_subpulse_counter_en = '1' then
                -- Incremento en 1, luego del tiempo de cada subpulso (Indicado por modulation_counter_expired)
                if modulation_counter_expired = '1' then
                    -- Reseteo en cuenta máxima
                    if (barker_subpulse_counter_reg = (barker_seq_num - 1)) then
                        barker_subpulse_counter_reg <= (others => '0');
                    -- Sinó incremento en 1
                    else
                        barker_subpulse_counter_reg <= (barker_subpulse_counter_reg + 1);
                    end if;
                else
                    barker_subpulse_counter_reg <= barker_subpulse_counter_reg;
                end if;
            else
                barker_subpulse_counter_reg <= barker_subpulse_counter_reg;
            end if;
        end if;
    end process;

    -- Selecciono la fase apropiada (0° o 180°) en función del bit correspondiente de la secuencia del código barker
    barker_phase_proc : process( barker_sequence,barker_subpulse_counter_reg )
    begin
        if (barker_sequence(to_integer(unsigned(barker_subpulse_counter_reg))) = '1') then
            barker_phase <= (others => '0');
        else
            barker_phase <= PHASE_OFFSET_180;
        end if;
    end process ; -- barker_phase_proc

    -- Este tipo de sentencia VHDL (2008) no simula en Vivado
    -- barker_phase <= (others => '0') when (barker_sequence(to_integer(unsigned(barker_subpulse_counter_reg))) = '1') else PHASE_OFFSET_180;
    ----------------------------------------------------------------------------------------            

    -- Envío una señal de resync al terminar un ciclo del pulso (Hubo timeout_n)
    -- Esto es válido en el modo pulsado
    resync <= (not pulse_timeout_n) and modulator_en;
    tdata_pinc_o <= (others => '0') when resync = '1' else                   
                    tdata_pinc;

    -- Habilito el DDS IPCore mientras el modulador esté habilitado
    dds_en_o <= modulator_en;
    
    -- Valores de salida al bus AXI-Stream
    m_axis_modulation_tdata <= "0000000" & resync & "00" & tdata_offset & "00" & tdata_pinc_o;
    m_axis_modulation_tvalid <= tvalid and modulator_en and m_axis_modulation_tready;

end;