LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX_4x1 IS
	PORT (
		input : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		output : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF MUX_4x1 IS
	SIGNAL int_sig : STD_LOGIC_VECTOR (3 DOWNTO 0);
	
BEGIN
	int_sig(0) <= input(0) AND NOT(sel(0)) AND NOT(sel(1));
	int_sig(1) <= input(1) AND sel(0) AND NOT(sel(1));
	int_sig(2) <= input(2) AND NOT(sel(0)) AND sel(1);
	int_sig(3) <= input(3) AND sel(0) AND sel(1);

	output <= int_sig(0) OR int_sig(1) OR int_sig(2) OR int_sig(3);
END struct;