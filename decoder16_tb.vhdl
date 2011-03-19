library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.general.all;

entity decoder16_tb is
end decoder16_tb;

architecture behav of decoder16_tb is
	component decoder16
		port (
			enable   : in  std_logic;
			sel      : in  unsigned(3 downto 0);
			data_out : out std_logic_vector(15 downto 0)
		);
	end component;

	signal enable   : std_logic;
	signal sel      : unsigned(3 downto 0) := "0000";
	signal data_out : std_logic_vector(15 downto 0);
begin
	decoder0: decoder16
	port map(enable, sel, data_out);

	process
		type pattern_type is record
			sel      : unsigned(3 downto 0);
			data_out : std_logic_vector(15 downto 0);
		end record;

		type pattern_array is array (natural range<>) of pattern_type;
		constant patterns : pattern_array := (
			("0000", "0000000000000001"),
			("0001", "0000000000000010"),
			("0010", "0000000000000100"),
			("0011", "0000000000001000"),
			("0100", "0000000000010000"),
			("0101", "0000000000100000"),
			("0110", "0000000001000000"),
			("0111", "0000000010000000"),
			("1000", "0000000100000000"),
			("1001", "0000001000000000"),
			("1010", "0000010000000000"),
			("1011", "0000100000000000"),
			("1100", "0001000000000000"),
			("1101", "0010000000000000"),
			("1110", "0100000000000000"),
			("1111", "1000000000000000")
		);
	begin
		enable <= '0';

		wait for 10 ns;

		assert data_out = (15 downto 0 => '0')
			report "output line active when enable = '0'" severity error;

		enable <= '1';

		for i in patterns'range loop
			sel <= patterns(i).sel;
			wait for 10 ns;

			assert data_out = patterns(i).data_out
				report "wrong output" severity error;
		end loop;

		assert false
			report "testing finished" severity note;
		wait;
	end process;
end behav;
