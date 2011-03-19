library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.general.all;

entity register_file_tb is
end register_file_tb;

architecture behav of register_file_tb is
	component register_file
		port (
			clk       : in  std_logic;
			store     : in  std_logic;
			reset     : in  std_logic;
			sel_in    : in  unsigned(3 downto 0);
			data_in   : in  word;
			sel_out1  : in  unsigned(3 downto 0);
			data_out1 : out word;
			sel_out2  : in  unsigned(3 downto 0);
			data_out2 : out word;

			pc_add_8  : in  std_logic
		);
	end component;

	signal clk       : std_logic;
	signal store     : std_logic;
	signal reset     : std_logic;
	signal sel_in    : unsigned(3 downto 0);
	signal data_in   : word;
	signal sel_out1  : unsigned(3 downto 0);
	signal data_out1 : word;
	signal sel_out2  : unsigned(3 downto 0);
	signal data_out2 : word;

	signal pc_add_8  : std_logic;
begin
	reg_file: register_file
	port map(clk, store, reset, sel_in, data_in, sel_out1, data_out1,
		sel_out2, data_out2, pc_add_8);

	process
	begin
		clk <= '0';
		store <= '0';
		reset <= '1';
		pc_add_8 <= '0';

		wait for 10 ns;

		for i in 0 to 15 loop
			sel_out1 <= to_unsigned(i, 4);
			sel_out2 <= to_unsigned(15 - i, 4);

			wait for 10 ns;

			assert data_out1 = (31 downto 0 => '0')
				report "bad initial value" severity error;
			assert data_out2 = (31 downto 0 => '0')
				report "bad initial value" severity error;
		end loop;

		reset <= '0';
		wait for 10 ns;

		store <= '1';
		for i in 0 to 15 loop
			sel_in <= to_unsigned(i, 4);
			data_in <= word(to_unsigned(i*10, 32));

			wait for 5 ns;
			clk <= '1';
			wait for 5 ns;
			clk <= '0';
		end loop;
		store <= '0';

		for i in 0 to 15 loop
			sel_out1 <= to_unsigned(i, 4);
			sel_out2 <= to_unsigned(i, 4);
			wait for 10 ns;
			assert data_out1 = data_out2 and data_out1 = word(to_unsigned(i*10, 32))
				report "bat stored value" severity error;
		end loop;

		pc_add_8 <= '1';
		wait for 10 ns;
		assert data_out1 = word(to_unsigned(158, 32))
			report "+8 adder not working" severity error;
			
		assert false
			report "testing finished" severity note;
		wait;
	end process;
end behav;
