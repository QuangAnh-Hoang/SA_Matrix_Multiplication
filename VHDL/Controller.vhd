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
use work.matrix_pack.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Controller is
    port (
        wi: in bin_matrix_1_t;
        s_wi: in sign_matrix_1_t;
        xi: in bin_matrix_2_t;
        s_xi: in sign_matrix_2_t; 

        clk, reset: in std_logic;

        yo: out bin_matrix_out_t;
        s_yo: out sign_matrix_out_t
    );
end Controller;

architecture Structural of Controller is
-- components --
component SA is
    port(        
        wi: in bin_matrix_1_t;
        s_wi: in sign_matrix_1_t;
        xi: in bin_array_2_t;
        s_xi: in sign_array_2_t;
        clk, ld: in std_logic;
        yo: out bin_array_out_t;
        s_yo: out sign_array_out_t
    );
end component;

-- custom types --
type state_t is (S_INIT, S_LOAD, S_INF);

-- signals --
signal ld         : std_logic;
signal not_ld     : std_logic;
signal curr_state : state_t := S_INIT;
signal next_state : state_t := S_LOAD;

signal x_vec      : bin_array_2_t;
signal s_x_vec    : sign_array_2_t;
signal y_vec      : bin_array_out_t;
signal s_y_vec    : sign_array_out_t;
signal done       : std_logic;
signal rs         : std_logic;

begin
not_ld <= not ld;

SA1: SA
    port map (
        wi => wi,
        s_wi => s_wi,
        xi => x_vec,
        s_xi => s_x_vec,
        clk => clk,
        ld => ld,
        yo => y_vec,
        s_yo => s_y_vec
    );

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
                if reset = '0' then 
                    next_state <= S_LOAD; 
                else 
                    next_state <= S_INIT;
                end if;
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
                
                if counter > MXU_H1+MXU_H2+1 then
                    done <= '1';
                end if;
                
                for i in x_vec'low to x_vec'high loop
                    set_flags(i) := '0'; 
                end loop;
                 
                if done = '0' then
                    for i in 0 to MXU_H2-1 loop --check the num iteration again
                        for j in 0 to MXU_W2-1 loop
                            -- input x
                            if counter = (i+j) then
                                x_vec(i) <= xi(i, j);
                                s_x_vec(i) <= s_xi(i, j);
                                set_flags(i) := '1';
                            else 
                                if set_flags(i) = '0' then
                                    x_vec(i) <= x"00";
                                    s_x_vec(i) <= '0';
                                end if;
                            end if;
                        end loop;
                    end loop;

                    for i in 0 to MXU_H1-1 loop
                        for j in 0 to MXU_W2-1 loop
                            --output y
                            if counter >= MXU_W1 and (i+j) = counter - MXU_W1 then
                                yo(i, j) <= y_vec(i);
                                s_yo(i, j) <= s_y_vec(i);
                            end if;
                        end loop;
                    end loop;                   
                else
                    next_state <= S_INIT;
                end if;
                
            --may add case where controller wait until the first output is out?
            --or maybe a condition to map y out in S_INF
        end case;
        curr_state <= next_state;
    end if;
end process;

end Structural;