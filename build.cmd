@echo off
set BUILD_FILES=general.vhdl bus_buffer.vhdl decoder16.vhdl latch.vhdl mux16.vhdl mux2.vhdl reg.vhdl register_file.vhdl
if [%1] neq [] (
	set BUILD_FILES=%BUILD_FILES% %1%.vhdl
)
for %%i in (%BUILD_FILES%) do (
	echo Analyzing %%i
	ghdl -a %%i
)
if [%1] neq [] (
	echo Elaborating...
	ghdl -e %1
	echo Running...
	ghdl -r %1 --vcd=waves.vcd
)
echo on