library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------- Clock Divider ----------------------------
entity Clock_Divider is
port ( CLOCK_50,res: in std_logic;
clock_out: out std_logic);
end Clock_Divider;
  
architecture bhv of Clock_Divider is
  
signal count: integer:=1;
signal tmp : std_logic := '0';
  
begin
  
process(CLOCK_50,res)
begin
if(res='0') then
count<=1;
tmp<='0';
elsif(CLOCK_50'event and CLOCK_50='1') then
count <=count+1;
if (count = 25000000) then
tmp <= NOT tmp;
count <= 1;
end if;
end if;
clock_out <= tmp;
end process;

end architecture;

------------------------ Displayer -----------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity NameDisplay is

	port(
	
		KEY : IN std_logic_vector(3 downto 0);
		SW : IN std_logic_vector(17 downto 0);
		CLOCK_50 : IN std_logic;
		
		LEDG : OUT std_logic_vector(4 downto 0);
		LCD_EN, LCD_RS, LCD_RW, LCD_ON, LCD_BLON : OUT std_logic;
		LCD_DATA : OUT std_logic_vector(7 downto 0)
		
		);

end entity;


architecture statemachine of NameDisplay is
	
	signal clk : std_logic;
	
	type state_type is (reset, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10);
	signal state : state_type := reset;

begin

	inst_clk_div : entity work.Clock_Divider(bhv)
		port map(
		
			res => KEY(2),
			CLOCK_50 => CLOCK_50,
			clock_out => clk
		
		);

LCD_BLON <= '1'; -- backlight is always on
LCD_ON <= '1'; -- LCD is always on
LCD_RW <= '0'; -- always writing to the LCD
LCD_EN <= clk;


	
	process(KEY, clk)

	variable counter : integer:=0;
	
	begin
		
		
		if(KEY(2) = '0') then --AND KEY(0) = '0'
		
			state <= reset;
			
		elsif (rising_edge(clk)) then
		
		
			case state is
			
				when reset =>
					LCD_RS <= '0';
					LCD_DATA <= "00111000";
					state <= s0;
					
					counter:=0;
				
				when s0 =>
					LCD_DATA <= "00111000";
					state <= s1;
					
				when s1 =>
					LCD_DATA <= "00001100";
					state <= s2;
					
				when s2 =>
					LCD_DATA <= "00000001";
					state <= s3;
					
				when s3 =>
					LCD_DATA <= "00000110";
					state <= s4;
					
				when s4 =>
					LCD_DATA <= "10000000";
					state <= s5;
					
				when s5 =>
					LCD_RS <= '1';
					LCD_DATA <= x"41";
					if (SW(2) = '1') then
						state <= s10;
					else
						state <= s6;
					end if;
					
					if (counter = 64) then
						state <= reset;
					end if;
					
					counter:=counter+1;
					
					
				when s6 =>
					LCD_DATA <= x"4D";
					if (SW(2) = '1') then
						state <= s5;
					else
						state <= s7;
					end if;
					
					if (counter = 64) then
						state <= reset;
					end if;
					
					counter:=counter+1;
					
					
				when s7 =>
					LCD_DATA <= x"49";
					if (SW(2) = '1') then
						state <= s6;
					else
						state <= s8;
					end if;
					
					if (counter = 64) then
						state <= reset;
					end if;
					
					counter:=counter+1;
					
			
				when s8 =>
					LCD_DATA <= x"52";
					if (SW(2) = '1') then
						state <= s7;
					else
						state <= s9;
					end if;
					
					if (counter = 64) then
						state <= reset;
					end if;
					
					counter:=counter+1;
					
					
				when s9 =>
					LCD_DATA <= x"41";
					if (SW(2) = '1') then
						state <= s8;
					else
						state <= s10;
					end if;
					
					if (counter = 64) then
						state <= reset;
					end if;
					
					counter:=counter+1;
					
					
				when s10 =>
					LCD_DATA <= x"4C";
					
					if (SW(2) = '1') then
						state <= s9;
					else
						state <= s5;
					end if;
					
					if (counter = 64) then
						state <= reset;
					end if;
					
					counter:=counter+1;
					
		
				when others =>
					LEDG(4) <= '1';
					
				
			end case;
		

			end if;
				
--	
	end process;


	
end architecture;
