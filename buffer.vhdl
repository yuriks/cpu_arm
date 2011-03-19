library ieee;
use ieee.std_logic_1164.all;
use work.general.all;

entity bus_buffer is
	generic (width : positive);
	port (
		data_in  : in  std_logic_vector(width-1 downto 0);
		data_out : out std_logic_vector(width-1 downto 0);
		enable   : in  std_logic
	);
end bus_buffer;

architecture rtl of bus_buffer is
begin
	data_out <= data_in when enable = '1' else (others => 'Z');
end architecture;
