# The MAC address final digits as written on the label on the TV Box
TV_MAC ?= 74:27
# The LAN IP address space (this depends on the router settings)
LAN_CIDR ?= 192.168.0.1/24
# The TV Box IP address to find
TVBOX_IP=""

# sudo tcpdump -env 2>&1 | grep ARP.*$(TV_MAC)
# sudo nmap -sn $(LAN_CIDR) | grep -B2 $(TV_MAC)
find-tvbox-ip:
	@sudo arp-scan 192.168.0.1/24 2>&1 | grep 74:27 | \
		awk '{print "\nThe IP should be: " $$1 " (for MAC " $$2 ")\n"}'
	$(eval TVBOX_IP=$(shell sudo arp-scan 192.168.0.1/24 2>&1 | grep 74:27 | awk '{print $$1}'))
	@echo "Stored this IP for the TV BOX: " $(TVBOX_IP)

ssh-into-tvbox: find-tvbox-ip
	sshpass -p 'coreelec' ssh -o StrictHostKeyChecking=no root@$(TVBOX_IP)
