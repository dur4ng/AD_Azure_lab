# Network Interface
resource "azurerm_network_interface" "thehackerish-vm-windows10-nic" {
  name                 = "thehackerish-vm-windows10-nic"
  location             = data.azurerm_resource_group.thehackerish-rg.location
  resource_group_name  = data.azurerm_resource_group.thehackerish-rg.name

  ip_configuration {
    name                          = "thehackerish-vm-windows10-config"
    subnet_id                     = azurerm_subnet.thehackerish-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.13.37.150"
  }
}

resource "azurerm_network_interface_nat_rule_association" "thehackerish-vm-windows10-nic-nat" {
  network_interface_id  = azurerm_network_interface.thehackerish-vm-windows10-nic.id
  ip_configuration_name = "thehackerish-vm-windows10-config"
  nat_rule_id           = azurerm_lb_nat_rule.thehackerish-lb-nat-rdp.id
}

# Virtual Machine
resource "azurerm_windows_virtual_machine" "thehackerish-vm-windows10" {
  name                = "hackerish-vm-windows10"
  computer_name       = var.win10-hostname
  size                = var.win10-size
  provision_vm_agent  = true
  enable_automatic_updates = true
  resource_group_name = data.azurerm_resource_group.thehackerish-rg.name
  location            = data.azurerm_resource_group.thehackerish-rg.location
  timezone            = var.timezone
  admin_username      = var.windows-user
  admin_password      = random_string.windowspass.result
  custom_data         = local.custom_data_content
  network_interface_ids = [
    azurerm_network_interface.thehackerish-vm-windows10-nic.id,
  ]

  os_disk {
    name                 = "thehackerish-vm-windows10-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-21h2-ent-g2"
    version   = "latest"
  }

  additional_unattend_content {
    setting = "AutoLogon"
    content = "<AutoLogon><Password><Value>${random_string.windowspass.result}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.windows-user}</Username></AutoLogon>"
  }

  additional_unattend_content {
    setting = "FirstLogonCommands"
    content = "${file("${path.module}/files/FirstLogonCommands.xml")}"
  }

  tags = {
    DoNotAutoShutDown = "yes"
  }
}
