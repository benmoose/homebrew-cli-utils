# _spinner <pid> [<msg>] - Show a spinner until the job with <pid> is finished
#
# The environment variable `SPINNER` selects the spinners.txt line number to use
# for the animation. If unset then a line is randomly chosen. SPINNER_COLOUR sets
# the animation colour.
builtin emulate -L zsh

[[ -t 1 ]] || return
[[ -n "$1" ]] || return 1

local -ar spinners=( $(<"$CLI_UTILS_DIR/share/cli-utils/data/spinners.txt") )
local -ir spinner_i=$(( ${SPINNER:-RANDOM} ))
local -ar frames=( "${(ws::)spinners[$(( spinner_i % $#spinners[@] + 1 ))]}" )
local -r pid_arg="$1" msg_arg="${2-Thinking}" colour_arg="${3-${SPINNER_COLOUR:-$CYAN}}"
local -i t

{
	\tput civis
	while \kill -0 "$pid_arg" &> /dev/null; do
		builtin printf "${CR}${BOLD}%s%s$NS %s$DIM...$NS " \
			"$colour_arg" "${frames[$(( t++ % $#frames[@] + 1 ))]}" "$msg_arg"
		\sleep 0.042
	done
} always {
	\tput cnorm
}
