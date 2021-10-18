# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# UpCloud referral to get $25 credits: https://upcloud.com/signup/?promo=Y2RZ4S
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Git repo with code: https://github.com/tappoz/scripting-utilities/upcloud-vm
resource "upcloud_server" "server-ag-tppz-vm" {
  hostname = "ag-tppz-vm"
  zone = "nl-ams1" # Availability zone https://developers.upcloud.com/1.3/5-zones/
  plan = "1xCPU-1GB"
  template {
    size = 25
    storage = "Ubuntu Server 20.04 LTS (Focal Fossa)"
  }
  network_interface {
    type = "public"
  }
  login {
    user = "root"
    keys = [
      file("${path.module}/../conf/root_ag_tppz_vm.pub"),
    ]
    create_password = false
  }
  connection {
    host = self.network_interface[0].ip_address # The server public IP address
    type = "ssh"
    user = "root"
    private_key = file("${path.module}/../conf/root_ag_tppz_vm")
  }
}
