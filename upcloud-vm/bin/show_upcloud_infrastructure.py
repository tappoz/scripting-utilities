#!/usr/bin/env python

import json
import os

import upcloud_api  # pip install upcloud-api==2.0.0


# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# UpCloud referral to get $25 credits: https://upcloud.com/signup/?promo=Y2RZ4S
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Git repo with code: https://github.com/tappoz/scripting-utilities/upcloud-vm
#
# UpCloud subaccount environment variables:
# ```bash
# export UPCLOUD_USERNAME="***username***"
# export UPCLOUD_PASSWORD="***password***"
# ```
# Command to generate a password: `makepasswd  --chars=100`
UC_WS_API_USER = os.environ["UPCLOUD_USERNAME"]
UC_WS_API_PSW = os.environ["UPCLOUD_PASSWORD"]

AG_SERVER_HOSTNAME = "ag-tppz-vm"


def inspect_servers():
    # retrieve server list
    manager = upcloud_api.CloudManager(UC_WS_API_USER, UC_WS_API_PSW)
    manager.authenticate()
    servers_list = manager.get_servers(populate=True)
    uc_servers = []
    for uc_server in servers_list:
        uc_servers.append(uc_server.to_dict())
    print(
        f"This is the list of current servers on UpCloud:\n{json.dumps(uc_servers, indent=2)}\n"
    )

    # check a specific server provided by *hostname*
    my_server = get_server_by_hostname(servers_list, AG_SERVER_HOSTNAME)
    print(f"What is '{AG_SERVER_HOSTNAME}' state? {my_server.state}")
    is_done = my_server.ensure_started()
    print(
        f"This '{AG_SERVER_HOSTNAME}' says it started? {is_done} what is its state? {my_server.state}"
    )

    # if you want to shutdown your server:
    #
    # is_done = my_server.shutdown()
    # print(
    #     f"This '{AG_SERVER_HOSTNAME}' says it stopped? {is_done} what is its state? {my_server.state}"
    # )


def get_server_by_hostname(servers, hostname):
    for s in servers:
        if s.hostname == hostname:
            print(f"Found the VM hostname we were looking for: {s.hostname}")
            return s
    return None


if __name__ == "__main__":
    inspect_servers()
