LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY instrALU IS
	PORT (
		Data1, Data2, Addr : IN STD_LOGIC_VECTOR (7 downto 0);
		Func : IN STD_LOGIC_VECTOR (5 downto 0);
		ALUOp : IN STD_LOGIC_VECTOR (1 downto 0);
		ALUSrc : IN STD_LOGIC;
		Result : OUT STD_LOGIC_VECTOR (7 downto 0);
		Zero, Ovr : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF instrALU IS
SIGNAL int_B : STD_LOGIC_VECTOR (7 downto 0);
SIGNAL int_Op : STD_LOGIC_VECTOR (2 downto 0);

COMPONENT unitALU_8bit IS
	PORT (
		A, B : IN STD_LOGIC_VECTOR (7 downto 0);
		Op : IN STD_LOGIC_VECTOR (2 downto 0);
		Output : OUT STD_LOGIC_VECTOR (7 downto 0);
		Zero, Ovr : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT controlALU IS
	PORT (
		Func : IN STD_LOGIC_VECTOR (5 downto 0);
		ALUOp : IN STD_LOGIC_VECTOR (1 downto 0);
		Op : OUT STD_LOGIC_VECTOR (2 downto 0)
	);
END COMPONENT;

COMPONENT MUX_2x1_8bit IS
	PORT (
		input0, input1  : IN STD_LOGIC_VECTOR (7 downto 0);
		SEL 		: IN STD_LOGIC;
		output 		: OUT STD_LOGIC_VECTOR (7 downto 0)
	);
END COMPONENT;

BEGIN
	MUX: MUX_2x1_8bit
	PORT MAP (input0 => Data2,
		  input1 => Addr,
		  SEL => ALUSrc,
		  output => int_B
	);

	ALU: unitALU_8bit
	PORT MAP (A => Data1,
		  B => int_B,
		  Op => int_Op,
		  Output => Result,
		  Zero => Zero,
		  Ovr => OPEN
	);

	CTRL: controlALU
	PORT MAP (Func => Func,
		  ALUOp => ALUOp,
		  Op => int_Op
	);
END struct;