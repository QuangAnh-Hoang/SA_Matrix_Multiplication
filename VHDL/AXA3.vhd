----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2021 05:22:11 PM
-- Design Name: 
-- Module Name: AXA3 - Behavioral
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

entity AXA3 is
    port(
        i_a, i_b, i_carry: in std_logic;
        o_sum, o_carry: out std_logic
    );
end AXA3;

architecture Behavioral of AXA3 is

begin
o_sum <= (i_a xnor i_b) and i_carry;
o_carry <= ((i_a xor i_b) and i_carry) or (i_a and i_b);

end Behavioral;
