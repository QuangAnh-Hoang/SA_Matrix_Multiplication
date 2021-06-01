----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/30/2021 04:31:52 PM
-- Design Name: 
-- Module Name: MUX_2_1 - Structural
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

entity MUX_2_1 is
    generic(n: natural:= 16);
    port(
        i_x, i_y: in std_logic_vector(n-1 downto 0);
        sel: in std_logic;
        o_z: out std_logic_vector(n-1 downto 0)
    );
end MUX_2_1;

architecture Structural of MUX_2_1 is

begin

o_z <= i_y when (sel = '1') else i_x;

end Structural;
