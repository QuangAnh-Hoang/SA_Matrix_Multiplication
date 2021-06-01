----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2021 10:21:11 PM
-- Design Name: 
-- Module Name: NFAx - Behavioral
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

entity NFAx is
    port(
        i_a, i_b, i_carry: in std_logic;
        o_sum, o_carry: out std_logic
    );
end NFAx;

architecture Structural of NFAx is
signal A_nand_B: std_logic;

begin

A_nand_B <= i_a nand i_b;
o_sum <= A_nand_B nand i_carry;
o_carry <= A_nand_B nand (not i_carry);

end Structural;
