library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.general.all;

entity latch_tb is
end latch_tb;

architecture behav of latch_tb is
	component latch
		generic (width : positive);
		port (
			data_in  : in  std_logic_vector(width-1 downto 0);
			data_out : out std_logic_vector(width-1 downto 0);
			enable   : in  std_logic
		);
	end component;

	signal data_in  : std_logic_vector(7 downto 0);
	signal data_out : std_logic_vector(7 downto 0);
	signal enable   : std_logic;
begin
	latch0: latch generic map(width => 8)
	port map(data_in, data_out, enable);

	process
	begin
		data_in <= "00110011";
		enable <= '1';

		wait for 10 ns;

		assert data_out = "00110011"
			report "input not saved when enable = 1" severity error;

		data_in <= "00001111";
		wait for 10 ns;

		assert data_out = "00001111"
			report "output not updated when data changed" severity error;

		enable <= '0';
		wait for 10 ns;
		data_in <= "00110011";
		wait for 10 ns;

		assert data_out = "00001111"
			report "output updated when enable = 0" severity error;

		assert false
			report "testing finished" severity note;
		wait;
	end process;
end behav;
