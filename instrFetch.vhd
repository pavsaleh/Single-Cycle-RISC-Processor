LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY instrFetch IS
	PORT (
		nextAddr : IN STD_LOGIC_VECTOR (7 downto 0);
		Rst, pcClk, instrClk : IN STD_LOGIC;
		Addr , incrAddr : OUT STD_LOGIC_VECTOR (7 downto 0);
		instruct : OUT STD_LOGIC_VECTOR (31 downto 0)
	);
END;

ARCHITECTURE struct OF instrFetch IS
SIGNAL int_instruct : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL int_Addr : STD_LOGIC_VECTOR (7 downto 0);

COMPONENT instrMem IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT highReg_8bit IS
	PORT (
			Input : IN STD_LOGIC_VECTOR (7 downto 0);
			Clk, En, Rst : IN STD_LOGIC;
			Output : OUT STD_LOGIC_VECTOR (7 downto 0)
	);
END COMPONENT;

COMPONENT Register_32bit IS
	PORT (
		in_Input			 : IN STD_LOGIC_VECTOR (31 downto 0);
		in_clk, in_en, in_resetbar	 : IN STD_LOGIC; 
		o_Output			 : OUT STD_LOGIC_VECTOR (31 downto 0) );
END COMPONENT;

COMPONENT aluCLA_8bit IS
	PORT (
		A, B : IN STD_LOGIC_VECTOR (7 downto 0);
		Cin : IN STD_LOGIC;
		Sum : OUT STD_LOGIC_VECTOR (7 downto 0);
		Cout, Ovr : OUT STD_LOGIC
	);
END COMPONENT;

BEGIN
	PC: highReg_8bit
	PORT MAP (Input => nextAddr,
		  Clk => pcClk,
		  En => '1',
		  Rst => Rst,
		  Output => int_Addr
	);

	INCR: aluCLA_8bit
	PORT MAP (A => int_Addr,
		  B => "00000001",
		  Cin => '0',
		  Sum => incrAddr,
		  Cout => OPEN,
		  Ovr => OPEN
	);
	
	ROM: instrMem	
	PORT MAP (address => int_Addr,
			  clock => instrClk,
			  q => int_instruct
	);

	STBL: Register_32bit
	PORT MAP (in_Input => int_instruct,
		  in_clk => instrClk,
		  in_en => '1',
		  in_resetbar => Rst,
		  o_Output => instruct
	);

	Addr <= int_Addr;
END struct;