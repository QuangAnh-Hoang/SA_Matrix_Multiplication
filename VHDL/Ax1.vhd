----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/17/2021 06:37:22 PM
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
    generic(n: natural:= 8);
    port(
        i_a, i_b: in std_logic_vector(n-1 downto 0);
        s_a, s_b: in std_logic;
        o_eout: out std_logic_vector(2*n-1 downto 0);
        s_eout: out std_logic
    );
end Ax1;

architecture Structural of Ax1 is

-- components --
component QTR_MXU_X is
    generic(a: natural:= 3;
            n: natural:= 4);
    port(
        i_c, i_d: in std_logic_vector(n-1 downto 0);
        o_eout: out std_logic_vector(2*n-1 downto 0)
    );
end component;

component QTR_MXU is
    generic(n: natural:= 4);
    port(
        i_c, i_d: in std_logic_vector(n-1 downto 0);
        o_eout: out std_logic_vector(2*n-1 downto 0)
    );
end component;

component QTR_MXU_U is
    generic(n: natural:= 4);
    port(
        i_c, i_d: in std_logic_vector(n-1 downto 0);
        o_eout: out std_logic_vector(2*n-1 downto 0)
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

component FA is
    port(
        i_a, i_b, i_carry: in std_logic;
        o_sum, o_carry: out std_logic
    );
end component;

-- signals --
signal o_quad1, o_quad2, o_quad3, o_quad4: std_logic_vector(n-1 downto 0);
signal temp_oper: std_logic_vector(n-1 downto 0);
--signal o_carry1: std_logic;
signal o_s, o_c, o_sum : std_logic_vector(3*n/2-1 downto 0);

begin

QUAD1: QTR_MXU_X 
    generic map (a => 3, n => 4)
    port map (
        i_c => i_a(n/2-1 downto 0),
        i_d => i_b(n/2-1 downto 0),
        o_eout => o_quad1
    );

--QUAD1: QTR_MXU_U
--    generic map (n => 4)
--    port map (
--        i_c => i_a(n/2-1 downto 0),
--        i_d => i_b(n/2-1 downto 0),
--        o_eout => o_quad1
--    );
    
QUAD2: QTR_MXU_U 
    generic map (n => 4)
    port map (
        i_c => i_a(n-1 downto n/2),
        i_d => i_b(n/2-1 downto 0),
        o_eout => o_quad2
    );

QUAD3: QTR_MXU_U
    generic map (n => 4)
    port map (
        i_c => i_a(n-1 downto n/2),
        i_d => i_b(n-1 downto n/2),
        o_eout => o_quad3
    );
    
QUAD4: QTR_MXU_U
    generic map (n => 4)
    port map (
        i_c => i_a(n/2-1 downto 0),
        i_d => i_b(n-1 downto n/2),
        o_eout => o_quad4
    );

temp_oper <= o_quad3(n/2-1 downto 0) & o_quad1(n-1 downto n/2);

ADDER: for i in 0 to 3*n/2-1 generate
    ADD: if i < n generate
        GEN_FA: FA 
            port map (
                i_a => o_quad2(i),
                i_b => o_quad4(i),
                i_carry => temp_oper(i),
                o_sum => o_s(i),
                o_carry => o_c(i+1)
            );
    end generate ADD;
    
    MSB_SUM: if i > n-1 generate
        o_s(i) <= o_quad3(i-n/2);
    end generate MSB_SUM;
    
    MSB_CARRY: if i > n generate
        o_c(i) <= '0';
    end generate MSB_CARRY;
    
    LSB_CARRY: if i = 0 generate
        o_c(i) <= '0';
    end generate LSB_CARRY;
        
end generate ADDER;

CL_ADDER: CLA
    generic map (n => 12)
    port map (
        i_a => o_s,
        i_b => o_c,
        o_sum => o_sum,
        o_carry => open
    );
    
o_eout <= o_sum & o_quad1(n/2-1 downto 0);
s_eout <= s_a xor s_b;

end Structural;
