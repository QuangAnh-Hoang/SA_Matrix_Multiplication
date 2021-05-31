----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/30/2021 04:27:15 PM
-- Design Name: 
-- Module Name: NEGATE - Behavioral
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

entity SIGNED_TO_UNSIGNED is
    generic(n: natural:= 16);
    port(
        x: in std_logic_vector(n downto 0);
        s_x: out std_logic;
        unsigned_x: out std_logic_vector(n-1 downto 0)
    );
end SIGNED_TO_UNSIGNED;

architecture Structural of SIGNED_TO_UNSIGNED is

-- components --
component MUX_2_1 is
    generic(n: natural:= 16);
    port(
        i_x, i_y: in std_logic_vector(n-1 downto 0);
        sel: in std_logic;
        o_z: out std_logic_vector(n-1 downto 0)
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

--signals --
signal x_m1: std_logic_vector(n downto 0);
signal rev_x: std_logic_vector(n-1 downto 0);

begin
-- neg. to pos. --
MINUS_ONE: CLA
    generic map(n => n+1)
    port map(
        i_a => x,
        i_b => (others => '1'),
        o_sum => x_m1,
        o_carry => open
    );

REV_POS: for i in 0 to n-1 generate
    rev_x(i) <= not x_m1(i);
end generate REV_POS;
    
-- MUX --
SIGNED_MUX: MUX_2_1
    generic map(n => n)
    port map(
        i_x => x(n-1 downto 0),
        i_y => rev_x,
        sel => x(n),
        o_z => unsigned_x
    );

s_x <= x(n);

end Structural;
