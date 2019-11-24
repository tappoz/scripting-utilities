# The Ethernet MAC address final digits as written on the label on the TV Box
TV_ETH_MAC ?= 74:27
TV_WLAN_MAC ?= 6C:C9
# The LAN IP address space (this depends on the router settings)
LAN_CIDR ?= 192.168.0.1/24
# CoreELEC username and password
COREELEC_USERNAME=root
COREELEC_PASSWORD=coreelec

# sudo tcpdump -env 2>&1 | grep ARP.*$(TV_ETH_MAC)
# sudo nmap -sn $(LAN_CIDR) | grep -B2 $(TV_ETH_MAC)
# @sudo arp-scan 192.168.0.1/24 2>&1 | grep $(TV_ETH_MAC) | \
# awk '{print "\nThe IP should be: " $$1 " (for MAC " $$2 ")\n"}'

# Notice this is definition, will not force immediate evaluation
TVBOX_ETH_IP= $(shell sudo arp-scan $(LAN_CIDR) 2>&1 | grep $(TV_ETH_MAC)  | awk '{print $$1}')
TVBOX_WIFI_IP=$(shell sudo arp-scan $(LAN_CIDR) 2>&1 | grep $(TV_WLAN_MAC) | awk '{print $$1}')
TVBOX_IP=$(or ${TVBOX_ETH_IP}, ${TVBOX_ETH_IP})

ssh-into-tvbox:
	IP=${TVBOX_IP} ; echo "IP=$$IP"
	sshpass -p $(COREELEC_PASSWORD) ssh -o StrictHostKeyChecking=no $(COREELEC_USERNAME)@${TVBOX_IP}

remote-configure:
	ansible-playbook configure-tv-box.yaml \
		-i ${TVBOX_IP}, -v \
		--extra-vars "ansible_user=$(COREELEC_USERNAME) ansible_ssh_pass=$(COREELEC_PASSWORD)"
