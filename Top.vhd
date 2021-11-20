LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Top IS
	PORT (
		ValueSel : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		nextCycle, GClk, GRst : IN STD_LOGIC;
		InstructionOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		MuxOut : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		BranchOut, ZeroOut, MemWriteOut, RegWriteOut : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF Top IS
	SIGNAL int_Instruct : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL int_PC, int_aluResult, int_Data1, int_Data2, int_WriteData, int_Other : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL int_ALUOp : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL int_Branch, int_Zero, int_MemWrite, int_RegWrite, int_Jump, int_RegDst, int_MemtoReg, int_ALUSrc : STD_LOGIC;
	SIGNAL int_nextCycle : STD_LOGIC;

	COMPONENT processor_8bit IS
		PORT (
			nextCycle, GClk, GRst : IN STD_LOGIC;
			Instruct : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			PC, aluResult, Data1, Data2, WriteData : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			ALUOp : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
			Branch, Zero, MemWrite, RegWrite, Jump, RegDst, MemtoReg, ALUSrc : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT MUX_8x1_8bit IS
		PORT (
			i_SEL : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			i_p0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			i_p1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			i_p2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			i_p3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			i_p4 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			i_p5 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			i_p6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			i_p7 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			o_MUX : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;

BEGIN
	int_Other(7) <= '0';
	int_Other(6) <= int_RegDst;
	int_Other(5) <= int_Jump;
	int_Other(4) <= NOT int_MemWrite;
	int_Other(3) <= int_MemtoReg;
	int_Other(2 DOWNTO 1) <= int_ALUOp;
	int_Other(0) <= int_ALUSrc;

	PROC : processor_8bit
	PORT MAP(
		nextCycle => nextCycle,
		GClk => GClk,
		GRst => GRst,
		Instruct => int_Instruct,
		PC => int_PC,
		aluResult => int_aluResult,
		Data1 => int_Data1,
		Data2 => int_Data2,
		WriteData => int_WriteData,
		ALUOp => int_ALUOp,
		Branch => int_Branch,
		Zero => int_Zero,
		MemWrite => int_MemWrite,
		RegWrite => int_RegWrite,
		Jump => int_Jump,
		RegDst => int_RegDst,
		MemtoReg => int_MemtoReg,
		ALUSrc => int_ALUSrc
	);

	MUX : MUX_8x1_8bit
	PORT MAP(
		i_SEL => ValueSel,
		i_p0 => int_PC,
		i_p1 => int_aluResult,
		i_p2 => int_Data1,
		i_p3 => int_Data2,
		i_p4 => int_WriteData,
		i_p5 => int_Other,
		i_p6 => int_Other,
		i_p7 => int_Other,
		o_MUX => MUXOut
	);

	int_nextCycle <= NOT nextCycle;
	InstructionOut <= int_Instruct;
	BranchOut <= int_Branch;
	ZeroOut <= int_Zero;
	MemWriteOut <= int_MemWrite;
	RegWriteOut <= int_RegWrite;
END struct;