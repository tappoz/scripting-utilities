terraform {
  required_providers {
    upcloud = {
      source = "UpCloudLtd/upcloud"
      version = "~>2.1.1"
    }
  }
}

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
provider "upcloud" {}
