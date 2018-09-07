# resource "oci_core_virtual_network" "MemcachedDemo" {
#   cidr_block     = "${var.VCN-CIDR}"
#   compartment_id = "${var.compartment_ocid}"
#   display_name   = "MemcachedDemo"
#   dns_label      = "MemcachedDemo"
# }

# resource "oci_core_internet_gateway" "MemcachedDemoIG" {
#   compartment_id = "${var.compartment_ocid}"
#   display_name   = "MemcachedDemoIG"
#   vcn_id         = "${oci_core_virtual_network.MemcachedDemo.id}"
# }

# resource "oci_core_route_table" "MemcachedDemoRT" {
#   compartment_id = "${var.compartment_ocid}"
#   vcn_id         = "${oci_core_virtual_network.MemcachedDemo.id}"
#   display_name   = "MemcachedDemoRT"

#   route_rules {
#     cidr_block        = "0.0.0.0/0"
#     network_entity_id = "${oci_core_internet_gateway.MemcachedDemoIG.id}"
#   }
# }

# resource "oci_core_security_list" "PublicSubnet" {
#   compartment_id = "${var.compartment_ocid}"
#   display_name   = "Public"
#   vcn_id         = "${oci_core_virtual_network.MemcachedDemo.id}"

#   egress_security_rules = [{
#     protocol    = "all"
#     destination = "0.0.0.0/0"
#   }]

#   ingress_security_rules = [{
#     tcp_options {
#       "max" = 80
#       "min" = 80
#     }

#     protocol = "6"
#     source   = "0.0.0.0/0"
#   },
#     {
#       tcp_options {
#         "max" = 443
#         "min" = 443
#       }

#       protocol = "6"
#       source   = "0.0.0.0/0"
#     },
#   ]
# }

# resource "oci_core_security_list" "PrivateAppSubnets" {
#   compartment_id = "${var.compartment_ocid}"
#   display_name   = "Security list for App servers"
#   vcn_id         = "${oci_core_virtual_network.MemcachedDemo.id}"

#   egress_security_rules = [{
#     protocol    = "all"
#     destination = "0.0.0.0/0"
#   }]

#   ingress_security_rules = [{
#     tcp_options {
#       "max" = 80
#       "min" = 80
#     }

#     protocol = "6"
#     source   = "0.0.0.0/0"
#   },
#     {
#       tcp_options {
#         "max" = 443
#         "min" = 443
#       }

#       protocol = "6"
#       source   = "0.0.0.0/0"
#     },
#   ]
# }

# resource "oci_core_security_list" "PrivateCacheSubnets" {
#   compartment_id = "${var.compartment_ocid}"
#   display_name   = "Security list for Cache servers"
#   vcn_id         = "${oci_core_virtual_network.MemcachedDemo.id}"

#   egress_security_rules = [{
#     protocol    = "all"
#     destination = "0.0.0.0/0"
#   }]

#   ingress_security_rules = [{
#     tcp_options {
#       "max" = 80
#       "min" = 80
#     }

#     protocol = "6"
#     source   = "0.0.0.0/0"
#   },
#     {
#       tcp_options {
#         "max" = 443
#         "min" = 443
#       }

#       protocol = "6"
#       source   = "0.0.0.0/0"
#     },
#   ]
# }

# resource "oci_core_security_list" "PrivateDBSubnets" {
#   compartment_id = "${var.compartment_ocid}"
#   display_name   = "Security list for DB servers"
#   vcn_id         = "${oci_core_virtual_network.MemcachedDemo.id}"

#   egress_security_rules = [{
#     protocol    = "all"
#     destination = "0.0.0.0/0"
#   }]

#   ingress_security_rules = [{
#     tcp_options {
#       "max" = 80
#       "min" = 80
#     }

#     protocol = "6"
#     source   = "0.0.0.0/0"
#   },
#     {
#       tcp_options {
#         "max" = 443
#         "min" = 443
#       }

#       protocol = "6"
#       source   = "0.0.0.0/0"
#     },
#   ]
# }

# resource "oci_core_security_list" "BastionSubnet" {
#   compartment_id = "${var.compartment_ocid}"
#   display_name   = "Bastion"
#   vcn_id         = "${oci_core_virtual_network.MemcachedDemo.id}"

#   egress_security_rules = [{
#     protocol    = "6"
#     destination = "0.0.0.0/0"
#   }]

#   ingress_security_rules = [{
#     tcp_options {
#       "max" = 22
#       "min" = 22
#     }

#     protocol = "6"
#     source   = "0.0.0.0/0"
#   }]
# }

resource "oci_core_subnet" "PublicSubnetAD1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block          = "${var.PubSubnetAD1CIDR}"
  display_name        = "PublicSubnetAD1"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${var.vcn_ocid}"
  route_table_id      = "${var.rt_ocid}"
  security_list_ids   = ["${var.security_list_ocid}"]

  dhcp_options_id = "${var.dhcp_options_ocid}"

  # defined_tags = "${
  #   map(
  #     "${oci_identity_tag_namespace.IT-depts.name}.${oci_identity_tag.Project.name}", "NameMesh-App"
  #   )
  # }"
}

resource "oci_core_subnet" "PublicSubnetAD2" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  cidr_block          = "${var.PubSubnetAD2CIDR}"
  display_name        = "PublicSubnetAD2"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${var.vcn_ocid}"
  route_table_id      = "${var.rt_ocid}"
  security_list_ids   = ["${var.security_list_ocid}"]

  dhcp_options_id = "${var.dhcp_options_ocid}"

  # defined_tags = "${
  #   map(
  #     "${oci_identity_tag_namespace.IT-depts.name}.${oci_identity_tag.Status.name}", "NameMesh-App"
  #   )
  # }"
}

# /* Load Balancer */


# resource "oci_load_balancer" "lb1" {
#   shape          = "100Mbps"
#   compartment_id = "${var.compartment_ocid}"


#   subnet_ids = [
#     "${oci_core_subnet.PublicSubnetAD1.id}",
#     "${oci_core_subnet.PublicSubnetAD2.id}",
#   ]


#   display_name = "lb1"
# }


# resource "oci_load_balancer_backendset" "lb-bes1" {
#   name             = "lb-bes1"
#   load_balancer_id = "${oci_load_balancer.lb1.id}"
#   policy           = "ROUND_ROBIN"


#   health_checker {
#     port                = "80"
#     protocol            = "HTTP"
#     response_body_regex = ".*"
#     url_path            = "/"
#   }
# }


# resource "oci_load_balancer_certificate" "lb-cert1" {
#   load_balancer_id   = "${oci_load_balancer.lb1.id}"
#   ca_certificate     = "-----BEGIN CERTIFICATE-----\nMIIBNzCB4gIJAKtwJkxUgNpzMA0GCSqGSIb3DQEBCwUAMCMxITAfBgNVBAoTGElu\ndGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0xNzA0MTIyMTU3NTZaFw0xODA0MTIy\nMTU3NTZaMCMxITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDBcMA0G\nCSqGSIb3DQEBAQUAA0sAMEgCQQDlM8lz3BFJA6zBlsF63k9ajPVq3Q1WQoHQ3j35\n08DRKIfwqfV+CxL63W3dZrwL4TrjqorP5CQ36+I6OWALH2zVAgMBAAEwDQYJKoZI\nhvcNAQELBQADQQCEjHVQJoiiVpIIvDWF+4YDRReVuwzrvq2xduWw7CIsDWlYuGZT\nQKVY6tnTy2XpoUk0fqUvMB/M2HGQ1WqZGHs6\n-----END CERTIFICATE-----"
#   certificate_name   = "certificate1"
#   private_key        = "-----BEGIN RSA PRIVATE KEY-----\nMIIBOgIBAAJBAOUzyXPcEUkDrMGWwXreT1qM9WrdDVZCgdDePfnTwNEoh/Cp9X4L\nEvrdbd1mvAvhOuOqis/kJDfr4jo5YAsfbNUCAwEAAQJAJz8k4bfvJceBT2zXGIj0\noZa9d1z+qaSdwfwsNJkzzRyGkj/j8yv5FV7KNdSfsBbStlcuxUm4i9o5LXhIA+iQ\ngQIhAPzStAN8+Rz3dWKTjRWuCfy+Pwcmyjl3pkMPSiXzgSJlAiEA6BUZWHP0b542\nu8AizBT3b3xKr1AH2nkIx9OHq7F/QbECIHzqqpDypa8/QVuUZegpVrvvT/r7mn1s\nddS6cDtyJgLVAiEA1Z5OFQeuL2sekBRbMyP9WOW7zMBKakLL3TqL/3JCYxECIAkG\nl96uo1MjK/66X5zQXBG7F2DN2CbcYEz0r3c3vvfq\n-----END RSA PRIVATE KEY-----"
#   public_certificate = "-----BEGIN CERTIFICATE-----\nMIIBNzCB4gIJAKtwJkxUgNpzMA0GCSqGSIb3DQEBCwUAMCMxITAfBgNVBAoTGElu\ndGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0xNzA0MTIyMTU3NTZaFw0xODA0MTIy\nMTU3NTZaMCMxITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDBcMA0G\nCSqGSIb3DQEBAQUAA0sAMEgCQQDlM8lz3BFJA6zBlsF63k9ajPVq3Q1WQoHQ3j35\n08DRKIfwqfV+CxL63W3dZrwL4TrjqorP5CQ36+I6OWALH2zVAgMBAAEwDQYJKoZI\nhvcNAQELBQADQQCEjHVQJoiiVpIIvDWF+4YDRReVuwzrvq2xduWw7CIsDWlYuGZT\nQKVY6tnTy2XpoUk0fqUvMB/M2HGQ1WqZGHs6\n-----END CERTIFICATE-----"
# }


# resource "oci_load_balancer_listener" "lb-listener1" {
#   load_balancer_id         = "${oci_load_balancer.lb1.id}"
#   name                     = "http"
#   default_backend_set_name = "${oci_load_balancer_backendset.lb-bes1.id}"
#   port                     = 80
#   protocol                 = "HTTP"
# }


# resource "oci_load_balancer_listener" "lb-listener2" {
#   load_balancer_id         = "${oci_load_balancer.lb1.id}"
#   name                     = "https"
#   default_backend_set_name = "${oci_load_balancer_backendset.lb-bes1.id}"
#   port                     = 443
#   protocol                 = "HTTP"


#   ssl_configuration {
#     certificate_name        = "${oci_load_balancer_certificate.lb-cert1.certificate_name}"
#     verify_peer_certificate = false
#   }
# }


# resource "oci_load_balancer_backend" "lb-be1" {
#   load_balancer_id = "${oci_load_balancer.lb1.id}"
#   backendset_name  = "${oci_load_balancer_backendset.lb-bes1.id}"
#   ip_address       = "${oci_core_instance.AppAD1.private_ip}"
#   port             = 5000
#   backup           = false
#   drain            = false
#   offline          = false
#   weight           = 1
# }


# resource "oci_load_balancer_backend" "lb-be2" {
#   load_balancer_id = "${oci_load_balancer.lb1.id}"
#   backendset_name  = "${oci_load_balancer_backendset.lb-bes1.id}"
#   ip_address       = "${oci_core_instance.AppAD2.private_ip}"
#   port             = 5000
#   backup           = false
#   drain            = false
#   offline          = false
#   weight           = 1
# }


# output "lb_public_ip" {
#   value = ["${oci_load_balancer.lb1.ip_addresses}"]
# }

