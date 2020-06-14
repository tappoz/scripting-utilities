#!/usr/bin/env bash

log() {
    printf "\n$(date +%Y-%m-%dT%T) ${1}\n\n"
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
