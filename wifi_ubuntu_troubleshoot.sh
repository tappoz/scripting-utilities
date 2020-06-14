#!/usr/bin/env bash

NC="\033[0m"
RED="\033[1;31m"
GRN="\033[1;32m"
YEL="\033[1;33m"
MAG="\033[1;35m"
CYN="\033[1;36m"

log() {
    printf "\n${RED}$(date +%Y-%m-%dT%T)${NC} ${GRN}${1}${NC}\n\n"
}

log "Check network interfaces that are DOWN..."
ip link | grep 'state.*DOWN' --color
# TODO dynamically extract the wifi network interface label
iwconfig wlp2s0
nmcli d | grep wifi
rfkill list


log "Restart the wifi interface"
# TODO if `nmcli` does not work, then `rfkill unblock 1`
nmcli radio wifi on

log "Show wifi network on reach..."
nmcli device wifi list

# TODO to connect to a wifi via command line: `nmtui`
