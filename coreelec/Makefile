# The Ethernet MAC address final digits as written on the label on the TV Box
TV_ETH_MAC ?= 74:27
TV_WLAN_MAC ?= 6C:C9
# The LAN IP address space (this depends on the router settings)
LAN_CIDR ?= 192.168.0.1/24
# The TV Box IP address to find
TVBOX_IP=""
# CoreELEC username and password
COREELEC_USERNAME=root
COREELEC_PASSWORD=coreelec

# sudo tcpdump -env 2>&1 | grep ARP.*$(TV_ETH_MAC)
# sudo nmap -sn $(LAN_CIDR) | grep -B2 $(TV_ETH_MAC)
# @sudo arp-scan 192.168.0.1/24 2>&1 | grep $(TV_ETH_MAC) | \
# awk '{print "\nThe IP should be: " $$1 " (for MAC " $$2 ")\n"}'
find-tvbox-eth-ip:
	@echo Checking the Ethernet IP address...
	$(eval TVBOX_ETH_IP=$(shell sudo arp-scan 192.168.0.1/24 2>&1 | grep $(TV_ETH_MAC) | awk '{print $$1}'))
	@echo Found an Ethernet IP address: "$(TVBOX_ETH_IP)"

# @sudo arp-scan 192.168.0.1/24 2>&1 | grep $(TV_WLAN_MAC) | \
# awk '{print "\nThe IP should be: " $$1 " (for MAC " $$2 ")\n"}'
# find-tvbox-wifi-ip:
# 	@echo Checking the Wifi IP address...
# 	$(eval TVBOX_WIFI_IP=$(shell sudo arp-scan 192.168.0.1/24 2>&1 | grep $(TV_WLAN_MAC) | awk '{print $$1}'))
# 	@echo Found a Wifi IP address: "$(TVBOX_WIFI_IP)"

# @[ "$(TVBOX_ETH_IP)" ] && TVBOX_IP:=$(TVBOX_ETH_IP) || ( echo TVBOX_IP:=$(TVBOX_WIFI_IP) )
find-tvbox-ip: find-tvbox-eth-ip # find-tvbox-wifi-ip
	$(eval TVBOX_IP=$(TVBOX_ETH_IP))
	@echo "Stored this IP for the TV BOX: " $(TVBOX_IP)

ssh-into-tvbox: find-tvbox-ip
	sshpass -p $(COREELEC_PASSWORD) ssh -o StrictHostKeyChecking=no $(COREELEC_USERNAME)@$(TVBOX_IP)

remote-configure: find-tvbox-ip
	ansible-playbook configure-tv-box.yaml \
		-i $(TVBOX_IP), -v \
		--extra-vars "ansible_user=$(COREELEC_USERNAME) ansible_ssh_pass=$(COREELEC_PASSWORD)"
