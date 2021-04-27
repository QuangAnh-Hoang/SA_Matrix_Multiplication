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
signal ci, di, carry_i, psi: two_d_array(7 downto 0, 7 downto 0);

begin

INIT_C: for j in 0 to 7 generate
    ci(0, j) <= i_c(j);
end generate INIT_C;

INIT_D: for i in 0 to 7 generate
    di(i, 0) <= i_d(i);
    carry_i(i, 0) <= '0';
end generate INIT_D;

ROW: for i in 0 to 3 generate
    COL: for j in 0 to 7 generate
        
        -- RHS
        ROW_0: if i = 0 and j < 7 generate
            di(i, j+1) <= ci(i, j) and di(i, j);
            ci(i+1, j) <= ci(i, j) and di(i, j);
        end generate ROW_0;

        ROW_0_5to0: if i = 0 and j < 6 generate
            psi(i+1,j) <= ci(i, j+1) and di(i, j+1);
        end generate ROW_0_5to0;
        
        psi(1,6) <= ci(0, 7) nand di(0, 7);
        psi(1,7) <= '1';
    
        ROW_0_7: if i = 0 and j = 7 generate
            ci(i+1, j) <= ci(i, j) nand di(i, j);
        end generate ROW_0_7;
        
        ROW_PPUx_RHS: if i /= 0 and i+j <= 3 generate
            PPU_X: PPUx port map(
                i_ci => ci(i, j),
                i_dj => di(i, j),
                i_carry => carry_i(i, j),
                i_sum => psi(i, j),
                o_ci => ci(i+1, j),
                o_dj => di(i, j+1),
                o_carry => carry_i(i, j+1),
                o_sum => psi()
            );
        end generate ROW_PPUx_RHS;
        
    end generate COL;

    COL_L: for j in 0 to 3 generate        
        -- LHS
        ROW_4: if i = 4 and j < 7 generate
            di(i, j+1) <= ci(i, j) and di(i, j);
            ci(i+1, j) <= ci(i, j) and di(i, j);
        end generate ROW_4;
        
        ROW_4_7: if i = 4 and j = 7 generate
            ci(i+1, j) <= ci(i, j) nand di(i, j);
        end generate ROW_4_7;
        
    end generate COL_L;        
end generate ROW;
end Structural;
