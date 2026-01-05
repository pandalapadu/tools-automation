resource "azurerm_network_interface" "main" {
  name = "${var.component}--nic"
  location = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name = "internal"
    subnet_id = data.azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}
resource "azurerm_network_security_group" "main" {
  name                = "${var.component}--nsg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = var.component
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = var.port
    destination_port_range     = var.port
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_public_ip" "main" {
  name = "${var.component}--pip"
  location = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method = "Static"
  sku = "Standard"
  ip_version = "IPv4"
}
##For Create an A record in DNS server
resource "azurerm_dns_a_record" "main" {
  name                = var.component           # subdomain (www.example.com)
  zone_name           = "azdevopsvenkat.site"
  resource_group_name = data.azurerm_resource_group.main.name
  ttl                 = 10                          # time-to-live in seconds
  records             = [azurerm_network_interface.main.private_ip_address]             # IP address of your VM or service
}
resource "azurerm_virtual_machine" "main" {
  name                = var.component
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size = "Standard_D2s_v3"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "94_gen2"
    version   = "9.4.2025040316" #exact version from az vm_show
  }
  storage_os_disk {
    name              = var.component
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.component
    admin_username = var.ssh_username
    admin_password = var.ssh_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    component = var.component
  }
}
