----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2021 07:08:58 PM
-- Design Name: 
-- Module Name: DFF - Behavioral
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

entity DFF is
    port(
        data_in: in std_logic;
        w_en: in std_logic;
        clk: in std_logic;
        data_out: out std_logic
    );
end DFF;

architecture Behavioral of DFF is

signal mem: std_logic := '0';

begin

process(clk)
begin
    if clk'event and clk = '1' then
        if w_en'event and w_en = '1' then
            mem <= data_in;
        else
            data_out <= mem;
        end if;
    end if;
end process;

end Behavioral;
