library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.general.all;

entity mux2_tb is
end mux2_tb;

architecture behav of mux2_tb is
	component mux2
		generic (width : positive);
		port (
			data_in1 : in  std_logic_vector(width-1 downto 0);
			data_in2 : in  std_logic_vector(width-1 downto 0);
			data_out : out std_logic_vector(width-1 downto 0);
			sel      : in  std_logic
		);
	end component;

	signal data_in1 : std_logic_vector(7 downto 0);
	signal data_in2 : std_logic_vector(7 downto 0);
	signal data_out : std_logic_vector(7 downto 0);
	signal sel      : std_logic;
begin
	mux0: mux2 generic map(width => 8)
	port map(data_in1, data_in2, data_out, sel);

	process
	begin
		data_in1 <= "00110011";
		data_in2 <= "00001111";
		sel <= '0';

		wait for 10 ns;

		assert data_out = "00110011"
			report "input not saved when enable = 1" severity error;

		data_in1 <= "11111111";
		wait for 10 ns;

		assert data_out = "11111111"
			report "output not updated when data changed" severity error;

		sel <= '1';
		wait for 10 ns;

		assert data_out = "00001111"
			report "input not saved when enable = 1" severity error;

		data_in2 <= "11111111";
		wait for 10 ns;

		assert data_out = "11111111"
			report "output not updated when data changed" severity error;

		assert false
			report "testing finished" severity note;
		wait;
	end process;
end behav;
