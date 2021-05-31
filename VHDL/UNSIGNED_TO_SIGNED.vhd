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

entity UNSIGNED_TO_SIGNED is
    generic(n: natural:= 16);
    port(
        x: in std_logic_vector(n-1 downto 0);
        s_x: in std_logic;
        signed_x: out std_logic_vector(n downto 0)
    );
end UNSIGNED_TO_SIGNED;

architecture Structural of UNSIGNED_TO_SIGNED is

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
signal pos_x, x_p1: std_logic_vector(n downto 0);
signal rev_x_pos: std_logic_vector(n downto 0);

begin
pos_x <= '0' & x;

-- pos. to neg. --
REV_POS: for i in 0 to n generate
    rev_x_pos(i) <= not pos_x(i);
end generate REV_POS;

PLUS_ONE: CLA
    generic map(n => n+1)
    port map(
        i_a => rev_x_pos,
        i_b => (0 => '1', others => '0'),
        o_sum => x_p1,
        o_carry => open
    );
    
-- MUX --
SIGNED_MUX: MUX_2_1
    generic map(n => n+1)
    port map(
        i_x => pos_x,
        i_y => x_p1,
        sel => s_x,
        o_z => signed_x
    );

end Structural;
