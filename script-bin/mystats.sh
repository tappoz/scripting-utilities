#!/usr/bin/env bash

# SETUP COLORS
RED_COLOR=`tput setaf 1`
GREEN_COLOR=`tput setaf 2`
RESET_COLOR=`tput sgr0`

# SETUP FUNCTIONS
log_msg() {
  # +%Y-%m-%dT%T
  echo -e >&2 "\n${GREEN_COLOR}`date +%T`${RED_COLOR} ${1}${RESET_COLOR}\n"
}

# https://www.thegeekstuff.com/2011/12/linux-performance-monitoring-tools/
# https://www.thegeekstuff.com/2011/03/sar-examples/
# sudo apt install sysstat
log_msg "overall I/O activities"
sar -b 1 3
log_msg "cumulative real-time CPU usage of all CPUs"
sar -u 1 3
log_msg "all CPUs"
sar -P ALL 1 1
log_msg "memory free"
sar -r 1 3
log_msg "swap space used"
sar -S 1 3
log_msg "individual block device I/O activities (pretty print)"
sar -p -d 1 1
log_msg "context switch per second"
sar -w 1 3
log_msg "network statistics"
sar -n DEV 1 1

log_msg "various stats"
iostat
log_msg "processors statistics"
# mpstat -A # equivalent to `mpstat -I ALL -u -P ALL`
mpstat -P ALL
log_msg "virtual memory statistics"
vmstat 1 10
log_msg "RAM usage"
free -mt

ntop
