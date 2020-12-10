#publicfriendlyname = "testlb"

custproj = "vmc999"

custowner = "vmcsupport"

custuin = "vmc123uincode"

computerip = ["192.168.56.131", "192.168.56.133"]


ingress_rules = {
  rule-a = {
    port        = "4401"
    protocol    = "HTTPS"
    cidr_blocks = ["0.0.0.0/0", "123.123.123.123/32"]
  },
  rule-2 = {
    port        = "443"
    protocol    = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

ingress_rules_v1 = [
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

