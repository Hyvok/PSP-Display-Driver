#
# Start simulation
#
if [info exists 1] {
	set main_entity ${1}
	set wavefile ${1}_tb_wave.do
	vsim ${main_entity}_tb
	do $wavefile
} else {
	echo "usage: start_simulation <tb_main_entity_name>"
}
