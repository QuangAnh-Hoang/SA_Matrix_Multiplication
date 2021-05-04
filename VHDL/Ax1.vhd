----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2021 09:07:37 PM
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

-- Variables --
type two_d_array is array (natural range <>, natural range <>) of std_logic; 
signal ci, di, psi, cri: two_d_array(7 downto 0, 7 downto 0);
signal p: std_logic_vector(15 downto 0);
signal cout: std_logic;

begin

INIT_C: for j in 0 to 7 generate
    ci(0, j) <= i_c(j);
    psi(0, j) <= '0';
end generate INIT_C;

INIT_D: for i in 0 to 7 generate
    di(i, 0) <= i_d(i);
    cri(1, 0) <= '0';
end generate INIT_D;

GY: for i in 0 to 7 generate
    GX: for j in 0 to 7 generate 

        G1: if i=0 and j<7 and j>0 generate
            ci(i+1, j) <= ci(i, j);
            di(i, j+1) <= di(i, j);
            psi(i+1, j-1) <= ci(i, j) and di(i, j);
        end generate G1;
        
        ci(1, 0) <= ci(0, 0);
        di(0, 1) <= di(0, 0);
        p(0) <= ci(0, 0) and di(0, 0);
        
        ci(1, 7) <= ci(0, 7);
        psi(1, 6) <= ci(0, 7) nand di(0, 7);
        
        G2: if i>0 and i<7 and j=0 generate
            ELM: PPU port map (
                i_ci => ci(i, j),
                i_dj => di(i, j),
                i_carry => cri(i, j),
                i_sum => psi(i, j),
                o_ci => ci(i+1, j),
                o_dj => di(i, j+1),
                o_carry => cri(i, j+1),
                o_sum => p(i)
            );
        end generate G2;
        
        G3: if i=7 and j<7 generate
            ELM: PPU port map (
                i_ci => ci(i, j),
                i_dj => di(i, j),
                i_carry => cri(i, j),
                i_sum => psi(i, j),
                o_ci => open,
                o_dj => di(i, j+1),
                o_carry => cri(i, j+1),
                o_sum => p(i+j)
            );
        end generate G3;

        G4: if i<7 and i>0 and j<7 and j>0 generate
            ELM: PPU port map (
                i_ci => ci(i, j),
                i_dj => di(i, j),
                i_carry => cri(i, j),
                i_sum => psi(i, j),
                o_ci => ci(i+1, j),
                o_dj => di(i, j+1),
                o_carry => cri(i, j+1),
                o_sum => psi(i+1, j-1)
            );
        end generate G4;

        G5: if i=1 and j=7 generate
            ELM: PPU port map (
                i_ci => ci(i, j),
                i_dj => di(i, j),
                i_carry => cri(i, j),
                i_sum => '1',
                o_ci => ci(i+1, j),
                o_dj => open,
                o_carry => psi(i+1, j),
                o_sum => psi(i+1, j-1)
            );
        end generate G5;

        G6: if i>1 and i<7 and j=7 generate
            ELM: PPU port map (
                i_ci => ci(i, j),
                i_dj => di(i, j),
                i_carry => cri(i, j),
                i_sum => psi(i, j),
                o_ci => ci(i+1, j),
                o_dj => open,
                o_carry => psi(i+1, j),
                o_sum => psi(i+1, j-1)
            );
        end generate G6;

        G7: if i=7 and j=7 generate
            ELM: PPU port map (
                i_ci => ci(i, j),
                i_dj => di(i, j),
                i_carry => cri(i, j),
                i_sum => psi(i, j),
                o_ci => open,
                o_dj => open,
                o_carry => cout,
                o_sum => p(i+j)
            );
        end generate G7;

        p(15) <= cout xor '1';

    end generate GX;
end generate GY;

o_eout <= p(15 downto 0);

end Structural;
