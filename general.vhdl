library ieee;
use ieee.std_logic_1164.all;

package general is
	subtype word is std_logic_vector(31 downto 0);
	type word_x16 is array(15 downto 0) of word;
end general;
