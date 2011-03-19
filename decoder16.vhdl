library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.general.all;

entity decoder16 is
	port (
		enable   : in  std_logic;
		sel      : in  unsigned(3 downto 0);
		data_out : out std_logic_vector(15 downto 0)
	);
end decoder16;

architecture rtl of decoder16 is
begin
	gen_label: for i in 0 to 15 generate
		data_out(i) <= enable when i = to_integer(sel) else '0';
	end generate;
end architecture;
