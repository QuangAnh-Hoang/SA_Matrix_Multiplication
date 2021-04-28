----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2021 10:42:04 PM
-- Design Name: 
-- Module Name: Ax1 - Structural
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

entity Ax1 is
    port(
        i_c, i_d: in std_logic_vector(7 downto 0);
        o_eout: out std_logic_vector(15 downto 0)
    );
end Ax1;

architecture Structural of Ax1 is

-- Components --
component PPU is
    port(
        i_ci, i_dj, i_carry, i_sum: in std_logic;
        o_ci, o_dj, o_carry, o_sum: out std_logic
    );
end component;

component PPUx is
    port(
        i_ci, i_dj, i_carry, i_sum: in std_logic;
        o_ci, o_dj, o_carry, o_sum: out std_logic
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

-- Variables --
type two_d_array is array (natural range <>, natural range <>) of std_logic; 
signal c, d, carry, ps: two_d_array(7 downto 0, 7 downto 0);

begin

INIT_C: for j in 0 to 7 generate
    c(0, j) <= i_c(j);
    c(4, j) <= i_c(j);
end generate INIT_C;

INIT_D: for i in 0 to 7 generate
    d(i, 0) <= i_d(i);
    carry(i, 0) <= '0';
end generate INIT_D;

AND_ROW: for j in 0 to 6 generate
    c(1, j) <= c(0, j) and d(0, j);
    d(0, j+1) <= d(0, j);
    
    c(5, j) <= c(0, j) and d(4, j);
    d(4, j+1) <= d(4, j);
end generate AND_ROW;

c(1, 7) <= c(0, 7) nand d(0,7);
c(5, 7) <= c(4, 7) nand d(4,7);

COL_PPUx: for j in 0 to 3 generate
    ROW_PPUx: for i in 1 to 3-j generate

    end generate ROW_PPUx;
end generate COL_PPUx;


end Structural;
