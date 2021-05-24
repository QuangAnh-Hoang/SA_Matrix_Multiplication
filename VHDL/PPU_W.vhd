----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2021 10:28:27 PM
-- Design Name: 
-- Module Name: PPU - Structural
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

entity PPU_W is
    port(
        i_ci, i_dj, i_sum, i_carry: in std_logic;
        o_ci, o_dj, o_sum, o_carry: out std_logic
    );
end PPU_W;

architecture Structural of PPU_W is

component FA
    port(
        i_a, i_b, i_carry: in std_logic;
        o_sum, o_carry: out std_logic
    );
end component;

signal C_and_D: std_logic;

begin

o_ci <= i_ci;
o_dj <= i_dj;
C_and_D <= i_ci and i_dj;

ADDER: FA port map (
    i_a => i_sum,
    i_b => C_and_D,
    i_carry => i_carry,
    o_sum => o_sum,
    o_carry => o_carry
);

end Structural;
