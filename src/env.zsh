set -a
CLI_UTILS_DIR="${${(%):-%N}:a:h:h:h}"
CR=$(tput cr)
EL=$(tput el)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
BOLD=$(tput bold)
DIM=$(tput dim)
NS=$(tput sgr0)
set +a
