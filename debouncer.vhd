library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity debouncer is
	port(
	clk : IN std_logic;
	KEY : IN std_logic_vector(3 downto 0);
	KEY_OUT : OUT std_logic_vector(3 downto 0)
	);

end entity;

architecture debouncing of debouncer is

	signal s0, s1, s2 : std_logic_vector(3 downto 0);

begin

	process(clk)
	begin
			
		if (rising_edge(clk)) then
		
			s0 <= KEY;
			s1 <= s0;
			s2 <= s1;
			
		end if;
		
	
	
	end process;
	KEY_OUT <= s0 and s1 and s2;


end architecture;