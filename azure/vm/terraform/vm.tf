resource "azurerm_resource_group" "myown_rg" {
  name = "${var.vm_id}-rg"
  location = "westeurope"
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.vm_id}-nsg"
  location            = "${azurerm_resource_group.myown_rg.location}"
  resource_group_name = "${azurerm_resource_group.myown_rg.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "vm_vn" {
  name                = "${var.vm_id}-vn"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.myown_rg.location}"
  resource_group_name = "${azurerm_resource_group.myown_rg.name}"
}

resource "azurerm_subnet" "vm_sn" {
  name                 = "${var.vm_id}-sn"
  resource_group_name  = "${azurerm_resource_group.myown_rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vm_vn.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "vm_pub_ip" {
  name                         = "${var.vm_id}-public-ip"
  location                     = "${azurerm_resource_group.myown_rg.location}"
  resource_group_name          = "${azurerm_resource_group.myown_rg.name}"
  allocation_method            = "Dynamic"
  domain_name_label            = "${var.vm_id}-pub"
}

resource "azurerm_network_interface" "vm_ni" {
  name                = "${var.vm_id}-nic"
  location            = "${azurerm_resource_group.myown_rg.location}"
  resource_group_name = "${azurerm_resource_group.myown_rg.name}"
  network_security_group_id = "${azurerm_network_security_group.vm_nsg.id}"

  ip_configuration {
    name                          = "${var.vm_id}-ipconf"
    subnet_id                     = "${azurerm_subnet.vm_sn.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm_pub_ip.id}"
  }
}

resource "azurerm_virtual_machine" "myown_vm" {
  name                  = "${var.vm_id}-vm"
  location              = "${azurerm_resource_group.myown_rg.location}"
  resource_group_name   = "${azurerm_resource_group.myown_rg.name}"
  network_interface_ids = ["${azurerm_network_interface.vm_ni.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true
  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_id}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.vm_id}-vm"
    admin_username = "${var.vm_user}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.vm_user}/.ssh/authorized_keys"
      // ssh user@vm-domain \
      //   -i ../ssh/myid_rsa \
      //   -o StrictHostKeyChecking=no
      key_data = "${file("${path.cwd}/../ssh/myid_rsa.pub")}"
    }
  }
}
