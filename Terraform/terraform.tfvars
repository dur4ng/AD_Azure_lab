# Terraform variables
# See 'variables.tf' for definitions

# Required
resource-group       = "AD_TEST"
ip-whitelist         = ["", ""]

# Optional (defaults are shown)
timezone             = "Central Europe Standard Time"
domain-name-label    = "thebollos"
domain-dns-name      = "bollos.local"
windows-user         = "dur4n"
linux-user           = "dur4n"
hackbox-hostname     = "hackbox"
dc-hostname          = "dc"
winserv2019-hostname = "winserv2019"
win10-hostname       = "win10"
win10-size           = "Standard_B1ms"
winserv2019-size     = "Standard_B1ms"
dc-size              = "Standard_B1ms"
hackbox-size         = "Standard_B1ms"
