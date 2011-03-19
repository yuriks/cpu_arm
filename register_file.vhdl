library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.general.all;

entity register_file is
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
end register_file;

architecture struct of register_file is
	component reg32
		generic (width : positive);
		port (
			clk      : in  std_logic;
			enable   : in  std_logic;
			reset    : in  std_logic;
			data_in  : in  std_logic_vector(width-1 downto 0);
			data_out : out std_logic_vector(width-1 downto 0)
		);
	end component;

	component decoder16
		port (
			enable   : in  std_logic;
			sel      : in  unsigned(3 downto 0);
			data_out : out std_logic_vector(15 downto 0)
		);
	end component;

	component mux16
		port (
			data_in  : in  word_x16;
			data_out : out word;
			sel      : in  unsigned(3 downto 0)
		);
	end component;

	signal enable_lines : std_logic_vector(15 downto 0);
	signal outdata_lines : word_x16;
	signal pc_pre_sum : word;
	signal summed_pc : word;
begin
	enable_dec: decoder16
	port map(enable => store, sel => sel_in, data_out => enable_lines);

	out1_mux: mux16
	port map(data_in => outdata_lines, data_out => data_out1,
		sel => sel_out1);

	out2_mux: mux16
	port map(data_in => outdata_lines, data_out => data_out2,
		sel => sel_out2);

	reg_gen: for i in 0 to 14 generate
		reg: reg32 generic map(width => 32)
		port map(clk => clk, enable => enable_lines(i), reset => reset, 
			data_in => data_in, data_out => outdata_lines(i));
	end generate;

	pc: reg32 generic map(width => 32)
	port map(clk => clk, enable => enable_lines(15), reset => reset, 
		data_in => data_in, data_out => pc_pre_sum);

	summed_pc <= std_logic_vector(unsigned(pc_pre_sum) + 8);
	outdata_lines(15) <= summed_pc when pc_add_8 = '1' else pc_pre_sum;
end architecture;
