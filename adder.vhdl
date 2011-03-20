library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.general.all;

entity adder is
	generic (width : positive);
	port (
		cin  : in  std_logic;
		op1  : in  std_logic_vector(width-1 downto 0);
		op2  : in  std_logic_vector(width-1 downto 0);
		sum  : out std_logic_vector(width-1 downto 0);
		cout : out std_logic;
		vout : out std_logic
	);
end adder;

architecture rtl of adder is
	constant empty_unsigned : unsigned := "";
	signal sum_tmp : std_logic_vector(width downto 0);
begin
	sum_tmp <= std_logic_vector(unsigned('0' & op1) + unsigned('0' & op2) +
			(empty_unsigned & cin));

	sum <= sum_tmp(width-1 downto 0);
	cout <= sum_tmp(width);
	vout <= (op1(width) xnor op2(width)) and (op1(width) xor sum_tmp(width-1));
end architecture;
