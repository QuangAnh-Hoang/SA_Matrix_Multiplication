----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2021 07:06:19 PM
-- Design Name: 
-- Module Name: REG - Behavioral
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

entity REG is
    generic(n: natural := 8);
    port(
        data_in: in std_logic_vector(n-1 downto 0);
        w_en: in std_logic;
        clk: in std_logic;
        data_out: out std_logic_vector(n-1 downto 0)
    );
end REG;

architecture Behavioral of REG is

component DFF is
    port(
        data_in: in std_logic;
        w_en: in std_logic;
        clk: in std_logic;
        data_out: out std_logic
    );
end component;

begin

DFF_GEN: for i in 0 to n-1 generate
    DFF_X: DFF port map (
        data_in => data_in(i),
        w_en => w_en,
        clk => clk,
        data_out => data_out(i)
    );
end generate DFF_GEN;

end Behavioral;
