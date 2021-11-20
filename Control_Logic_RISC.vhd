LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Control_Unit IS
	PORT (
		i_OP : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		o_RegDst, o_Jump, O_Branch, o_MemRead : OUT STD_LOGIC;
		o_MemtoReg, o_MemWrite, o_ALUsrc, o_RegWrite : OUT STD_LOGIC;
		o_aluOP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0));
END;

ARCHITECTURE struct OF Control_Unit IS
	SIGNAL int_Rtype, int_lw, int_sw, int_beq, int_jump : STD_LOGIC;
BEGIN
	int_Rtype <= NOT(i_OP(5)) AND NOT(i_OP(4)) AND NOT (i_OP(3)) AND NOT(i_OP(2)) AND NOT (i_OP(1)) AND NOT(i_OP(0));
	int_lw <= i_OP(5) AND NOT(i_OP(4)) AND NOT(i_OP(3)) AND NOT(i_OP(2)) AND i_OP(1) AND i_OP(0);
	int_sw <= i_OP(5) AND NOT(i_OP(4)) AND i_OP(3) AND NOT(i_OP(2)) AND i_OP(1) AND i_OP(0);
	int_beq <= NOT(i_OP(5)) AND NOT(i_OP(4)) AND NOT (i_OP(3)) AND i_OP(2) AND NOT (i_OP(1)) AND NOT(i_OP(0));
	int_jump <= NOT(i_OP(5)) AND NOT(i_OP(4)) AND NOT (i_OP(3)) AND NOT(i_OP(2)) AND i_OP(1) AND NOT(i_OP(0));

	o_RegDst <= int_Rtype;
	o_jump <= int_jump;
	O_Branch <= int_beq;
	o_MemRead <= int_lw;
	o_MemtoReg <= int_lw;
	o_MemWrite <= int_sw;
	o_ALUsrc <= int_sw OR int_lw;
	o_RegWrite <= int_lw OR int_Rtype;
	o_aluOP(0) <= int_beq;
	o_aluOP(1) <= int_Rtype;
END struct;