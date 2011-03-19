library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.general.all;

entity bus_buffer_tb is
end bus_buffer_tb;

architecture behav of bus_buffer_tb is
	component bus_buffer
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
	buf0: bus_buffer generic map(width => 8)
	port map(data_in, data_out, enable);

	process
	begin
		enable <= '0';

		wait for 10 ns;

		assert data_out = (7 downto 0 => 'Z')
			report "output not Z when disabled" severity error;

		enable <= '1';
		data_in <= "01100110";

		wait for 10 ns;

		assert data_out = "01100110";

		assert false
			report "testing finished" severity note;
		wait;
	end process;
end behav;
