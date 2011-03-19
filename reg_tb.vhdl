library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.general.all;

entity reg_tb is
end reg_tb;

architecture behav of reg_tb is
	component reg
		generic (width : positive);
		port (
			clk      : in  std_logic;
			enable   : in  std_logic;
			reset    : in  std_logic;
			data_in  : in  std_logic_vector(width-1 downto 0);
			data_out : out std_logic_vector(width-1 downto 0)
		);
	end component;

	signal clk      : std_logic;
	signal enable   : std_logic;
	signal reset    : std_logic;
	signal data_in  : std_logic_vector(31 downto 0);
	signal data_out : std_logic_vector(31 downto 0);
begin
	reg0: reg generic map(width => 32)
	port map(clk, enable, reset, data_in, data_out);

	process
	begin
		clk <= '0';
		enable <= '0';
		reset <= '1';

		wait for 10 ns;
		reset <= '0';
		wait for 10 ns;

		assert data_out = (31 downto 0 => '0')
			report "bad initial value" severity error;

		enable <= '1';
		data_in <= x"aaaaaaaa";

		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
		clk <= '0';
		enable <= '0';
		data_in <= x"55555555";
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
		clk <= '0';

		assert data_out = x"aaaaaaaa"
			report "bad saved value" severity error;

		reset <= '1';
		wait for 10 ns;
		assert data_out = (31 downto 0 => '0')
			report "bad reset value" severity error;

		assert false
			report "testing finished" severity note;
		wait;
	end process;
end behav;
