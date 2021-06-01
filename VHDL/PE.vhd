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
        s_x, s_w, s_y_in: in std_logic;

        x_out: out std_logic_vector(n-1 downto 0);
        y_out: out std_logic_vector(2*n-1 downto 0);
        s_x_out, s_y_out: out std_logic;
        
        weight_en: in std_logic;
        tristate_en: in std_logic;
        clk: in std_logic
    );
end PE;

architecture Behavioral of PE is

-- components --
component Ax1 is
    generic(n: natural:= 8);
    port(
        i_a, i_b: in std_logic_vector(n-1 downto 0);
        s_a, s_b: in std_logic;
        o_eout: out std_logic_vector(2*n-1 downto 0);
        s_eout: out std_logic
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

component U_CLA is
    generic(n: natural:= 16);
    port(
        i_a, i_b: in std_logic_vector(n-1 downto 0);
        s_a, s_b: in std_logic;
        o_sum: out std_logic_vector(n-1 downto 0);
        s_sum: out std_logic
    );
end component;

component DFF is
    port(
        data_in: in std_logic;
        w_en: in std_logic;
        clk: in std_logic;
        data_out: out std_logic
    );
end component;

-- signals --
signal weight_tmp : std_logic_vector(n-1 downto 0);
signal mult_tmp, adder_tmp : std_logic_vector(2*n-1 downto 0);
signal s_mult_tmp: std_logic;
signal not_clk: std_logic;

signal signed_y_in, signed_mult_tmp, signed_adder_tmp: std_logic_vector(2*n downto 0);
signal s_adder_tmp: std_logic;

begin

not_clk <= not clk;

WEIGHT_REG: REG
    generic map(n => n)
    port map(
        data_in => w_in,
        w_en => weight_en,
        clk => clk,
        data_out => weight_tmp
    );

MULT: Ax1
    generic map(n => n)
    port map(
        i_a => x_in, 
        s_a => s_x,
        i_b => weight_tmp,
        s_b => s_w,
        o_eout => mult_tmp,
        s_eout => s_mult_tmp
    );

UNSIGNED_ADDER: U_CLA
    generic map(n => 2*n)
    port map(
        i_a => y_in,
        s_a => s_y_in,
        i_b => mult_tmp,
        s_b => s_mult_tmp,
        o_sum => adder_tmp,
        s_sum => s_adder_tmp
    );

OUTPUT_Y_REG: REG
    generic map(n => 2*n)
    port map(
        data_in => adder_tmp,
        w_en => tristate_en,
        clk => not_clk,
        data_out => y_out
    );

OUT_S: DFF
    port map(
        data_in => s_adder_tmp,
        w_en => tristate_en,
        clk => not_clk,
        data_out => s_y_out
    );

x_out <= x_in;
s_x_out <= s_x;

end Behavioral;
