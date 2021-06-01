----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/30/2021 07:15:07 PM
-- Design Name: 
-- Module Name: U_CLA - Behavioral
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

entity U_CLA is
    generic(n: natural:= 16);
    port(
        i_a, i_b: in std_logic_vector(n-1 downto 0);
        s_a, s_b: in std_logic;
        o_sum: out std_logic_vector(n-1 downto 0);
        s_sum: out std_logic
    );
end U_CLA;

architecture Behavioral of U_CLA is
-- components --
component CLA is
    generic(n: natural:= 8);
    port(
        i_a, i_b: in std_logic_vector(n-1 downto 0);
        o_sum: out std_logic_vector(n-1 downto 0);
        o_carry: out std_logic
    );
end component;

component UNSIGNED_TO_SIGNED is
    generic(n: natural:= 16);
    port(
        x: in std_logic_vector(n-1 downto 0);
        s_x: in std_logic;
        signed_x: out std_logic_vector(n downto 0)
    );
end component;

component SIGNED_TO_UNSIGNED is
    generic(n: natural:= 16);
    port(
        x: in std_logic_vector(n downto 0);
        s_x: out std_logic;
        unsigned_x: out std_logic_vector(n-1 downto 0)
    );
end component;

-- signals --
signal signed_a, signed_b, signed_sum: std_logic_vector(n downto 0);

begin
S_A_IN: UNSIGNED_TO_SIGNED
    generic map(n => n)
    port map(
        x => i_a,
        s_x => s_a,
        signed_x => signed_a
    );

S_B_IN: UNSIGNED_TO_SIGNED
    generic map(n => n)
    port map(
        x => i_b,
        s_x => s_b,
        signed_x => signed_b
    );
    
ADDER: CLA
    generic map(n => n+1)
    port map(
        i_a => signed_a, 
        i_b => signed_b,
        o_sum => signed_sum,
        o_carry => open
    );

UNSIGNED_ADDER: SIGNED_TO_UNSIGNED
    generic map(n => n)
    port map(
        x => signed_sum,
        s_x => s_sum,
        unsigned_x => o_sum
    );

end Behavioral;
