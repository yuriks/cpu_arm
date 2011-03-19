library ieee;
use ieee.std_logic_1164.all;
use work.general.all;

entity reg is
	generic (width : positive);
	port (
		clk      : in  std_logic;
		enable   : in  std_logic;
		reset    : in  std_logic;
		data_in  : in  std_logic_vector(width-1 downto 0);
		data_out : out std_logic_vector(width-1 downto 0)
	);
end reg;

architecture rtl of reg is
begin
	process (clk, reset)
	begin
		if (reset = '1') then
			data_out <= (others => '0');
		elsif (clk'event and clk = '1' and enable = '1') then
			data_out <= data_in;
		end if;
	end process;
end architecture;
