library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

package matrix_pack is
    constant MXU_H1: natural:= 2; -- Hw = n
    constant MXU_W1: natural:= 3; -- Ww = mk^2
    constant MXU_H2: natural:= 3; -- Hx = mk^2
    constant MXU_W2: natural:= 2; -- Wx = j (data slices applied on filter)
    constant BIT_WIDTH:     natural := 8;
    constant SCALE_FACTOR:  real := 256.0;
    
    type matrix_1_t is array (0 to MXU_H1-1, 0 to MXU_W1-1) of real;
    type matrix_2_t is array (0 to MXU_H2-1, 0 to MXU_W2-1) of real;
    type matrix_out_t is array (0 to MXU_H1-1, 0 to MXU_W2-1) of real;
    
    -- in W_row --
    type bin_array_1_t is array (0 to MXU_W1-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
    -- in X_column --
    type bin_array_2_t is array (0 to MXU_H2-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
    -- out Y_column --
    type bin_array_out_t is array (0 to MXU_H1-1) of std_logic_vector(2*BIT_WIDTH-1 downto 0);
    
    type sign_matrix_1_t is array (0 to MXU_H1-1, 0 to MXU_W1-1) of std_logic;
    type sign_matrix_2_t is array (0 to MXU_H2-1, 0 to MXU_W2-1) of std_logic;
    type sign_array_2_t is array (0 to MXU_H2-1) of std_logic;
    type sign_array_out_t is array (0 to MXU_H1-1) of std_logic;
    type sign_matrix_out_t is array (0 to MXU_H1-1, 0 to MXU_W2-1) of std_logic;
    
    type bin_matrix_1_t is array (0 to MXU_H1-1, 0 to MXU_W1-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
    type bin_matrix_2_t is array (0 to MXU_H2-1, 0 to MXU_W2-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
    type bin_matrix_y_t is array (0 to MXU_H1-1, 0 to MXU_W1-1) of std_logic_vector(2*BIT_WIDTH-1 downto 0);
    type bin_matrix_out_t is array (0 to MXU_H1-1, 0 to MXU_W2-1) of std_logic_vector(2*BIT_WIDTH-1 downto 0);
end package matrix_pack;