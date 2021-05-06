module NFAx (
    i_a, i_b, i_carry,
    o_sum, o_carry
);
    input i_a, i_b, i_carry;
    output o_sum, o_carry;
    wire A_nand_B;
    wire not_i_carry;

    NAND2_X1 NA0 (.A1(i_a), .A2(i_b), .ZN(A_nand_B));
    NAND2_X1 NA1 (.A1(A_nand_B), .A2(i_carry), .ZN(o_sum));
    NAND2_X1 NA2 (.A1(A_nand_B), .A2(not_i_carry), .ZN(o_carry));

endmodule
