----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2021 09:56:27 PM
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

entity Ax0 is
    generic(n: natural:= 8);
    port(
        i_c, i_d: in std_logic_vector(n-1 downto 0);
        o_eout: out std_logic_vector(2*n-1 downto 0)
    );
end Ax0;

architecture Structural of Ax0 is

-- Components --
component PPU_W is
    port(
        i_ci, i_dj, i_carry, i_sum: in std_logic;
        o_ci, o_dj, o_carry, o_sum: out std_logic
    );
end component;

component PPU_G is
    port(
        i_ci, i_dj, i_carry, i_sum: in std_logic;
        o_ci, o_dj, o_carry, o_sum: out std_logic
    );
end component;

component FA is
    port(
        i_a, i_b, i_carry: in std_logic;
        o_sum, o_carry: out std_logic
    );
end component;

-- Variables --
type two_d_array is array (natural range <>, natural range <>) of std_logic; 
signal ci, di, psi, cri: two_d_array(n-1 downto 0, n-1 downto 0);
signal p: std_logic_vector(2*n-1 downto 0);
signal cout: std_logic;

begin

INIT_C: for j in 0 to n-1 generate
    ci(0, j) <= i_c(j);
    psi(0, j) <= '0';
end generate INIT_C;

INIT_D: for i in 0 to n-1 generate
    di(i, 0) <= i_d(i);
    cri(i, 0) <= '0';
end generate INIT_D; 
    
LOOP_D: for i in 0 to n-1 generate
    LOOP_C: for j in 0 to n-1 generate
        
        G0: if i = 0 and j = 0 generate
            ci(i+1, j) <= ci(i, j);
            di(i, j+1) <= di(i, j);
            p(0) <= ci(i, j) and di(i, j);
        end generate G0;
        
        G1: if i = 0 and j < n-1 and j > 0 generate
            ci(i+1, j) <= ci(i, j);
            di(i, j+1) <= di(i, j);
            psi(i+1, j-1) <= ci(i, j) and di(i, j);
        end generate G1;
    
        G2: if i = 0 and j = n-1 generate
            ci(i+1, j) <= ci(i, j);
            psi(i+1, j-1) <= ci(i, j) nand di(i, j);
            psi(i+1, j) <= '1';
        end generate G2;
    
        G3: if i > 0 and i < n-1 and j = 0 generate
            PPC: PPU_W port map (
                i_ci => ci(i, j),
                i_dj => di(i, j),
                i_sum => psi(i, j),
                i_carry => cri(i, j),
                o_ci => ci(i+1, j),
                o_dj => di(i, j+1),
                o_sum => p(i),
                o_carry => cri(i, j+1)
            );
        end generate G3;
    
        G4: if i > 0 and i < n-1 and j > 0 and j < n-1 generate
            PPC: PPU_W port map (
                i_ci => ci(i, j),
                i_dj => di(i, j),
                i_sum => psi(i, j),
                i_carry => cri(i, j),
                o_ci => ci(i+1, j),
                o_dj => di(i, j+1),
                o_sum => psi(i+1, j-1),
                o_carry => cri(i, j+1)
            );
        end generate G4;
    
        G5: if i > 0 and i < n-1 and j = n-1 generate
            PPC: PPU_G port map (
                i_ci => ci(i, j),
                i_dj => di(i, j),
                i_sum => psi(i, j),
                i_carry => cri(i, j),
                o_ci => ci(i+1, j),
                o_dj => open,
                o_sum => psi(i+1, j-1),
                o_carry => psi(i+1, j)
            );
        end generate G5;
    
        G6: if i = n-1 and j < n-1 generate
            PPC: PPU_G port map (
                i_ci => ci(i, j),
                i_dj => di(i, j),
                i_sum => psi(i, j),
                i_carry => cri(i, j),
                o_ci => open,
                o_dj => di(i, j+1),
                o_sum => p(i+j),
                o_carry => cri(i, j+1)
            );
        end generate G6;
    
        G7: if i = n-1 and j = n-1 generate
            PPC: PPU_W port map (
                i_ci => ci(i, j),
                i_dj => di(i, j),
                i_sum => psi(i, j),
                i_carry => cri(i, j),
                o_ci => open,
                o_dj => open,
                o_sum => p(i+j),
                o_carry => cout
            );
        end generate G7;
    
    end generate LOOP_C;
end generate LOOP_D;

SIGN_ADDER: FA port map (
    i_a => '1',
    i_b => cout,
    i_carry => '0',
    o_sum => p(2*n-1),
    o_carry => open
);

o_eout <= p;

end Structural;
