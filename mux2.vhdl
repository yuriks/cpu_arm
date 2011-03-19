library ieee;
use ieee.std_logic_1164.all;
use work.general.all;

entity mux2 is
	generic (width : positive);
	port (
		data_in1 : in  std_logic_vector(width-1 downto 0);
		data_in2 : in  std_logic_vector(width-1 downto 0);
		data_out : out std_logic_vector(width-1 downto 0);
		sel      : in  std_logic
	);
end mux2;

architecture rtl of mux2 is
begin
	data_out <=	data_in1 when sel = '0' else data_in2;
end architecture;
