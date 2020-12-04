publicfriendlyname = "testurl"

custproj = "vmc999"

custowner = "vmcsupport"

custuin   = "vmc123uincode"

computerip = ["192.168.200.0"]

ingress_rules = [
  {
    port        = 443
    protocol    = "HTTPS"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    port        = 23
    protocol    = "HTTPS"
    cidr_blocks = "192.168.200.1/32"
  },
]
