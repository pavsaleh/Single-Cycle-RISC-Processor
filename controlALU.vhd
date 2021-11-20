LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controlALU IS
	PORT (
		Func : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		ALUOp : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		Op : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
	);
END;

ARCHITECTURE struct OF controlALU IS
BEGIN
	Op(2) <= ALUOp(0) OR (Func(1) AND ALUOp(1));
	Op(1) <= ((NOT ALUOp(1)) OR (NOT Func(2)));
	Op(0) <= ALUOp(1) AND (Func(3) OR Func(0));
END struct;