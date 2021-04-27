----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2021 09:36:33 PM
-- Design Name: 
-- Module Name: CLA - Structural
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

entity CLA is
    generic(n: natural:= 8);
    port(
        i_a, i_b: in std_logic_vector(n-1 downto 0);
        o_sum: out std_logic_vector(n-1 downto 0);
        o_carry: out std_logic
    );
end CLA;

architecture Structural of CLA is
    component FA is
        port(
            i_a, i_b, i_carry: in std_logic;
            o_sum, o_carry: out std_logic
        );
    end component;
    
    signal w_G: std_logic_vector(n-1 downto 0);
    signal w_P: std_logic_vector(n-1 downto 0);
    signal w_C: std_logic_vector(n downto 0);
    signal w_S: std_logic_vector(n-1 downto 0);

begin

    CLA_ADDER: for i in 0 to n-1 generate
        CLA_ADDER_i: FA 
            port map (
                i_a => i_a(i),
                i_b => i_b(i),
                i_carry => w_C(i),
                o_sum => w_S(i),
                o_carry => open
            );
    end generate;

    GEN_CLA: for j in 0 to n-1 generate
        w_G(j) <= i_a(j) and i_b(j);
        w_P(j) <= i_a(j) or i_b(j);
        w_C(j+1) <= w_G(j) or (w_P(j) and w_C(j));
    end generate;

    w_C(0) <= '0';
    o_carry <= w_C(n);
    o_sum <= w_S;

end Structural;
