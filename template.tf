# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "tempgp96" {
    name     = "myRG999"
    location = "eastus"

    tags = {
        environment = "Terraform Demo123"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "tempnetwork" {
    name                = "myVnet123"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.tempgp96.name

    tags = {
        environment = "Terraform Demo123"
    }
}

# Create subnet
resource "azurerm_subnet" "terraformtempsubnet" {
    name                 = "tempSubnet123"
    resource_group_name  = azurerm_resource_group.tempgp96.name
    virtual_network_name = azurerm_virtual_network.tempnetwork.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "terraformtemppublicip" {
    name                         = "myPublicIP123"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.tempgp96.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo123"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "mytempnsg" {
    name                = "tempNetworkSecurityGroup123"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.tempgp96.name

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

    tags = {
        environment = "Terraform Demo123"
    }
}

# Create network interface
resource "azurerm_network_interface" "mytempnic" {
    name                      = "tempNIC123"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.tempgp96.name

    ip_configuration {
        name                          = "tempNicConfiguration123"
        subnet_id                     = azurerm_subnet.terraformtempsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.terraformtemppublicip.id
    }
     
    tags = {
        environment = "Terraform Demo123"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "exampletemp" {
    network_interface_id      = azurerm_network_interface.mytempnic.id
    network_security_group_id = azurerm_network_security_group.mytempnsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.tempgp96.name
    }

    byte_length = 8
}                  

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageacctemp" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.tempgp96.name
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Terraform Demo123"
    }
}

# Create (and display) an SSH key
resource "tls_private_key" "temp_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" {
    value = tls_private_key.temp_ssh.private_key_pem
    sensitive = true
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "terraformvmtp" {
    name                  = "devops-platform"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.tempgp96.name
    network_interface_ids = [azurerm_network_interface.mytempnic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "myvm"
    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {   
        username       = "azureuser"
        public_key     = tls_private_key.temp_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageacctemp.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Demo123"
   }
}
resource "azurerm_sql_server" "extemp969" {
  name                         = "testserver96-ap-2022"
  resource_group_name          = azurerm_resource_group.tempgp96.name
  location                     = "eastus"
  version                      = "12.0"
  administrator_login          = "serverlogin"
  administrator_login_password = "S_123erverpassword"

  tags = {
    environment = "testing"
  }
}