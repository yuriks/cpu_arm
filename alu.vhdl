library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.general.all;

entity alu is
	port (
		op_sel       : in  std_logic_vector(2 downto 0);
		add_carry    : in  std_logic;

		-- Mostly used for pass-through,
		-- though carry afects computation.
		flag_shift_c : in  std_logic;
		flag_c_in    : in  std_logic;
		flag_v_in    : in  std_logic;

		flag_n       : out std_logic;
		flag_z       : out std_logic;
		flag_c       : out std_logic;
		flag_v       : out std_logic;

		data_in1     : in  word;
		data_in2     : in  word;
		data_out     : out word
	);
end alu;

architecture rtl of alu is
	component adder
		generic (width : positive);
		port (
			cin  : in  std_logic;
			op1  : in  std_logic_vector(width-1 downto 0);
			op2  : in  std_logic_vector(width-1 downto 0);
			sum  : out std_logic_vector(width-1 downto 0);
			cout : out std_logic;
			vout : out std_logic
		);
	end component;

	signal adder_op1    : word;
	signal adder_op2    : word;
	signal adder_op2neg : word;
	signal adder_cout   : std_logic;
	signal adder_vout   : std_logic;
	signal adder_sum    : word;
	signal final_val    : word;
begin
	adder0: adder generic map (width => 32)
	port map(cin => flag_c_in, op1 => adder_op1, op2 => adder_op2neg,
		sum => adder_sum, cout => adder_cout, vout => adder_vout);

	process (op_sel, add_carry, flag_shift_c, flag_c_in, flag_v_in,
		data_in1, data_in2, adder_op1, adder_op2, adder_op2neg,
		adder_cout, adder_vout, adder_sum, final_val)
	begin
		if op_sel(2) = '0' then
			-- bitwise ops
			case op_sel(1 downto 0) is
				when "00" => final_val <= data_in1 and data_in2;
				when "01" => final_val <= data_in1 xor data_in2;
				when "10" => final_val <= data_in1 or data_in2;
				when others => final_val <= not data_in2;
			end case;
		else
			-- arithmetic ops
			if (op_sel(1) or op_sel(0)) = '1' then
				final_val <= adder_sum;
			else
				final_val <= data_in2;
			end if;
		end if;
		if op_sel(2) = '0' or op_sel = "100" then
			flag_c <= flag_shift_c;
			flag_v <= flag_v_in;
		else
			flag_c <= adder_cout;
			flag_v <= adder_vout;
		end if;
	end process;

	adder_op1 <= data_in2 when (op_sel(1 downto 0) = "11") else data_in1;
	adder_op2 <= data_in1 when (op_sel(1 downto 0) = "11") else data_in2;
	adder_op2neg <= std_logic_vector(-signed(adder_op2))
		when op_sel(1) = '1' else adder_op2;

	flag_n <= final_val(31);
	flag_z <= '1' when (final_val = (final_val'range => '0')) else '0';
end architecture;
