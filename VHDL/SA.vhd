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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

package matrix_type is
    constant MXU_H1: natural:= 2; -- Hw = n
    constant MXU_W1: natural:= 2; -- Ww = mk^2
    constant MXU_H2: natural:= 2; -- Hx = mk^2
    constant MXU_W2: natural:= 2; -- Wx = j (data slices applied on filter)
    constant BIT_WIDTH:     natural := 8;
    constant SCALE_FACTOR:  real := 256.0;
    
    type matrix_1_t is array (0 to MXU_W1-1, 0 to MXU_H1-1) of real;
    type matrix_2_t is array (0 to MXU_W2-1, 0 to MXU_H2-1) of real;
    type matrix_out_t is array (0 to MXU_W2-1, 0 to MXU_H1-1) of real;
    
    -- in W_row --
    type bin_array_1_t is array (0 to MXU_H1-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
    -- in X_column --
    type bin_array_2_t is array (0 to MXU_H2-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
    -- out Y_column --
    type bin_array_out_t is array (0 to MXU_W2-1) of std_logic_vector(2*BIT_WIDTH-1 downto 0);
    
    type bin_matrix_1_t is array (0 to MXU_W1-1, 0 to MXU_H1-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
    type bin_matrix_2_t is array (0 to MXU_W2-1, 0 to MXU_H2-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
    type bin_matrix_out_t is array (0 to MXU_W2-1, 0 to MXU_H1-1) of std_logic_vector(2*BIT_WIDTH-1 downto 0);
end package matrix_type;

use work.matrix_type.all;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity SA is
    port(        
        wi: in bin_matrix_1_t;
        xi: in bin_array_2_t;
        clk, ld: in std_logic;
        yo: out bin_array_out_t;
        done: out std_logic
    );
end SA;

architecture Structural of SA is

-- components --
component PE is
    generic(n: natural:= 8);
    port (
        x_in, w_in: in std_logic_vector(n-1 downto 0);
        y_in: in std_logic_vector(2*n-1 downto 0);

        x_out: out std_logic_vector(n-1 downto 0);
        y_out: out std_logic_vector(2*n-1 downto 0);
        
        weight_en: in std_logic;
        tristate_en: in std_logic;
        clk: in std_logic
    );
end component;

-- signals --
signal not_ld: std_logic;
signal tmp_y_out: bin_matrix_out_t;

begin
not_ld <= not ld;


--i: #-ing of cols
--j: #-ing of rows
SA_X_GEN: for i in 0 to MXU_W1-1 generate
    SA_Y_GEN: for j in 0 to MXU_H1-1 generate
        G0: if i = 0 generate --first col where ps_in = 0
            PE_GEN: PE
                generic map(n => BIT_WIDTH)
                port map(
                    w_in => wi(i,j),
                    x_in => xi(i),
                    y_in => (others => '0'),
                    x_out => open,
                    y_out => tmp_y_out(i,j),
                    weight_en => ld,
                    tristate_en => not_ld,
                    clk => clk
                );
        end generate G0;
        
        G1: if i > 0 generate
            PE_GEN: PE
                generic map(n => BIT_WIDTH)
                port map(
                    w_in => wi(i,j),
                    x_in => xi(i),
                    y_in => tmp_y_out(i-1,j),
                    x_out => open,
                    y_out => tmp_y_out(i,j),
                    weight_en => ld,
                    tristate_en => not_ld,
                    clk => clk
                );
        end generate G1;
    end generate SA_Y_GEN;
end generate SA_X_GEN;

MAP_Y_OUT: for j in 0 to MXU_H1-1 generate
    yo(j) <= tmp_y_out(MXU_W1-1, j);
end generate MAP_Y_OUT;

process(clk, ld)
    variable counter: integer range 0 to 31;
begin
    if clk'event and clk='1' then
        if ld='1' then
            done <= '0';
            counter := 1;
        else
            if counter <= MXU_H1+MXU_H2+1 then
                counter := counter + 1;
            else
                done <= '1';
            end if;
        end if;
    end if;
end process;

end Structural;
