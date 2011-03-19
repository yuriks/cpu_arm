library ieee;
use ieee.std_logic_1164.all;
use work.general.all;

entity latch is
	generic (width : positive);
	port (
		data_in  : in  std_logic_vector(width-1 downto 0);
		data_out : out std_logic_vector(width-1 downto 0);
		enable   : in  std_logic
	);
end latch;

architecture rtl of latch is
begin
	process (enable, data_in)
	begin
		if (enable = '1') then
			data_out <= data_in;
		end if;
	end process;
end architecture;
