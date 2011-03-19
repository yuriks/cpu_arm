library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.general.all;

entity mux16 is
	port (
		data_in  : in  word_x16;
		data_out : out word;
		sel      : in  unsigned(3 downto 0)
	);
end mux16;

architecture rtl of mux16 is
begin
	data_out <= data_in(to_integer(sel));
end architecture;
