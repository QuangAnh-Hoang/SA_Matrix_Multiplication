----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/25/2021 08:58:50 PM
-- Design Name: 
-- Module Name: SA - Structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
use work.matrix_pack.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity SA is
    port(
        wi: in bin_matrix_1_t;
        s_wi: in sign_matrix_1_t;
        xi: in bin_array_2_t;
        s_xi: in sign_array_2_t;
        clk, ld: in std_logic;
        yo: out bin_array_out_t;
        s_yo: out sign_array_out_t
    );
end SA;

architecture Structural of SA is

-- components --
component PE is
    generic(n: natural:= 8);
    port (
        x_in, w_in: in std_logic_vector(n-1 downto 0);
        y_in: in std_logic_vector(2*n-1 downto 0);
        s_x, s_w, s_y_in: in std_logic;

        x_out: out std_logic_vector(n-1 downto 0);
        y_out: out std_logic_vector(2*n-1 downto 0);
        s_x_out, s_y_out: out std_logic;
        
        weight_en: in std_logic;
        tristate_en: in std_logic;
        clk: in std_logic
    );
end component;

-- signals --
signal not_ld: std_logic;
signal tmp_y_out: bin_matrix_y_t;
signal tmp_s_y_out: sign_matrix_1_t;

begin
not_ld <= not ld;


--i: #-ing of cols
--j: #-ing of rows
SA_Y_GEN: for i in 0 to MXU_H1-1 generate 
    SA_X_GEN: for j in 0 to MXU_W1-1 generate
        G0: if j = 0 generate --first col where ps_in = 0
            PE_GEN: PE
                generic map(n => BIT_WIDTH)
                port map(
                    w_in => wi(i,j),
                    x_in => xi(j),
                    y_in => (others => '0'),
                    s_w  => s_wi(i,j),
                    s_x  => s_xi(j),
                    s_y_in => '0',

                    x_out => open,
                    y_out => tmp_y_out(i,j),
                    s_x_out => open,
                    s_y_out => tmp_s_y_out(i,j),

                    weight_en => ld,
                    tristate_en => not_ld,
                    clk => clk
                );
        end generate G0;
        
        G1: if j > 0 generate
            PE_GEN: PE
                generic map(n => BIT_WIDTH)
                port map(
                    w_in => wi(i,j),
                    x_in => xi(j),
                    y_in => tmp_y_out(i,j-1),
                    s_w  => s_wi(i,j),
                    s_x  => s_xi(j),
                    s_y_in => tmp_s_y_out(i,j-1),

                    x_out => open,
                    y_out => tmp_y_out(i,j),
                    s_x_out => open,
                    s_y_out => tmp_s_y_out(i,j),

                    weight_en => ld,
                    tristate_en => not_ld,
                    clk => clk
                );
        end generate G1;
    end generate SA_X_GEN;
end generate SA_Y_GEN;

MAP_Y_OUT: for i in 0 to MXU_H1-1 generate
    yo(i) <= tmp_y_out(i, MXU_W1-1);
    s_yo(i) <= tmp_s_y_out(i, MXU_W1-1);
end generate MAP_Y_OUT;

--process(clk, ld)
--    variable counter: integer range 0 to 31;
--begin
--    if reset = '1' then
--        done <= '0';
--        counter := 0;
--    else 
--        if clk'event and clk='1' then
--            if ld='1' then
--                done <= '0';
--                counter := 0;
--            else
--                if counter <= MXU_H1+MXU_H2+1 then
--                    counter := counter + 1;
--                else
--                    done <= '1';
--                end if;
--            end if;
--        end if;
--    end if;
--end process;

end Structural;
