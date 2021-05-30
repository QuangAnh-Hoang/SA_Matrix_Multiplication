----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2021 06:32:34 PM
-- Design Name: 
-- Module Name: PE - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PE is
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
end PE;

architecture Behavioral of PE is

-- components --
component Ax1 is
    generic(a: natural:= 3;
            n: natural:= 8);
    port(
        i_c, i_d: in std_logic_vector(n-1 downto 0);
        o_eout: out std_logic_vector(2*n-1 downto 0)
    );
end component;

component REG is
    generic(n: natural := 8);
    port(
        data_in: in std_logic_vector(n-1 downto 0);
        w_en: in std_logic;
        clk: in std_logic;
        data_out: out std_logic_vector(n-1 downto 0)
    );
end component;

component CLA is
    generic(n: natural:= 8);
    port(
        i_a, i_b: in std_logic_vector(n-1 downto 0);
        o_sum: out std_logic_vector(n-1 downto 0);
        o_carry: out std_logic
    );
end component;

-- signals --
signal weight_tmp : std_logic_vector(n-1 downto 0);
signal mult_tmp, adder_tmp : std_logic_vector(2*n-1 downto 0);



begin
WEIGHT_REG: REG
    generic map(n => n)
    port map(
        data_in => w_in,
        w_en => weight_en,
        clk => clk,
        data_out => weight_tmp
    );

MULT: Ax1
    generic map(
        a => 3,
        n => n
    )
    port map(
        i_c => x_in, 
        i_d => weight_tmp,
        o_eout => mult_tmp
    );
    
ADDER: CLA
    generic map(n => 2*n)
    port map(
        i_a => y_in, 
        i_b => mult_tmp,
        o_sum => adder_tmp,
        o_carry => open
    );

TRISTATE_BUFFER: for i in 0 to 2*n-1 generate
    y_out(i) <= adder_tmp(i) when (tristate_en = '1') else 'Z';
end generate TRISTATE_BUFFER;

x_out <= x_in;

end Behavioral;
