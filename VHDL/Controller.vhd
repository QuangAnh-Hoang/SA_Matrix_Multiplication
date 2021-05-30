----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/25/2021 08:58:50 PM
-- Design Name: 
-- Module Name: SA - Structural
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

package matrix_type is
    constant MXU_H1: natural:= 2; -- Hw = n
    constant MXU_W1: natural:= 2; -- Ww = mk^2
    constant MXU_H2: natural:= 2; -- Hx = mk^2
    constant MXU_W2: natural:= 2; -- Wx = j (data slices applied on filter)
    constant BIT_WIDTH:     natural := 8;
    constant SCALE_FACTOR:  real := 256.0;
    
    type matrix_1_t is array (0 to MXU_W1-1, 0 to MXU_H1-1) of real;
    type matrix_2_t is array (0 to MXU_W2-1, 0 to MXU_H2-1) of real;
    type matrix_out_t is array (0 to MXU_W2-1, 0 to MXU_H1-1) of real;
    
    -- in W_row --
    type bin_array_1_t is array (0 to MXU_H1-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
    -- in X_column --
    type bin_array_2_t is array (0 to MXU_H2-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
    -- out Y_column --
    type bin_array_out_t is array (0 to MXU_W2-1) of std_logic_vector(2*BIT_WIDTH-1 downto 0);
    
    type bin_matrix_1_t is array (0 to MXU_W1-1, 0 to MXU_H1-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
    type bin_matrix_2_t is array (0 to MXU_W2-1, 0 to MXU_H2-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
    type bin_matrix_out_t is array (0 to MXU_W2-1, 0 to MXU_H1-1) of std_logic_vector(2*BIT_WIDTH-1 downto 0);
end package matrix_type;

use work.matrix_type.all;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Controller is
    port (
        wi: in bin_matrix_1_t;
        xi: in bin_matrix_2_t;
        clk, reset: in std_logic;
        yo: out bin_matrix_out_t
    )
end Controller;


architecture Structural of Controller is

-- components --
component SA is
    port(        
        wi: in bin_matrix_1_t;
        xi: in bin_array_2_t;
        clk, ld, reset: in std_logic;
        yo: out bin_array_out_t;
        done: out std_logic
    );    
end component;

-- custom types
type state_t is (S_INIT, S_LOAD, S_INF);
-- signals --
signal ld         : std_logic;
signal not_ld     : std_logic;
signal curr_state : state_t := S_INIT;
signal next_state : next_t := S_LOAD;
signal w_mat      : bin_matrix_1_t;
signal x_vec      : bin_array_2_t;
signal y_vec      : bin_array_out_t;
signal done       : std_logic;
signal rs         : std_logic;

begin

    SA1: SA
    port map (
        wi => w_mat,
        xi => x_vec,
        clk => clk,
        ld => ld,
        yo => y_vec,
        done => done,
        reset => rs
    );
        

    not_ld <= not ld;

    process(clk)
        variable counter: integer range 0 to 31;
        variable set_flags: std_logic_vector(0 to MXU_H2-1); --same size as x_vec vector
    begin
        if reset = '1' then
            curr_state <= S_INIT;
        end if;

        if clk'event and clk = '1' then    
            case curr_state is
                when S_INIT =>
                    rs <= '1';
                    ld <= '0';
                    counter := 0;
                    if reset = '0' then next_state <= S_LOAD; 
                    else next_state <= S_INIT;
                when S_LOAD =>
                    rs <= '0';
                    ld <= '1';
                    if counter > 0 then --wait 1 cycle for loading
                        next_state <= S_INF;                          
                    else 
                        next_state <= S_LOAD;
                        counter := counter + 1;
                    end if;
                when S_INF =>
                    rs <= '0';
                    ld <= '0';
                    counter := counter + 1;
                    for i in x_vec'low to x_vec'high loop
                        set_flags(i) <= '0'; 
                    end loop;
                     
                    if done = '0' then
                        for i in 0 to MXU_W2-1 loop --check the num iteration again
                            for j in 0 to MXU_H2-1 loop
                                -- input x
                                if counter = (i+j) then
                                    x_vec(j) <= xi(j, i);
                                    set_flag(j) <= '1';
                                else 
                                    if set_flag(j) = '0' then
                                        x_vec(j) <= x"00";
                                    end if;
                                end if;
                            end loop;
                        end loop;

                        for i in 0 to MXU_W2-1 loop
                            for j in 0 to MXU_H1-1 loop
                                --output y
                                if counter > MXU_W1 and (i+j) = counter - MXU_W1 then
                                    yo(j, i) <= y_vec(j);
                                end if
                            end loop
                        end loop                        
                    else
                        next_state = S_INIT
                    end if;
                    
                --may add case where controller wait until the first output is out?
                --or maybe a condition to map y out in S_INF
            end case;
        end if;
    end process;


end Structural;