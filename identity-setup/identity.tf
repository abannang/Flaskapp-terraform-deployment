resource "oci_identity_group" "NetworkAdmins" {
  name        = "NetworkAdmins"
  description = "group created for Network Admins"
}

resource "oci_identity_policy" "policy-NW-Admins" {
  name           = "policy-NW-Admins"
  description    = "policy created for Network admins"
  compartment_id = "${var.compartment_ocid}"

  statements = ["Allow group ${oci_identity_group.NetworkAdmins.name} to manage virtual-network-family in compartment ${var.compartment_name}"]
}

resource "oci_identity_group" "DBAdmins" {
  name        = "DBAdmins"
  description = "group created for Database Admins"
}

resource "oci_identity_policy" "policy-DB-Admins" {
  name           = "policy-DB-Admins"
  description    = "policy created for Database admins"
  compartment_id = "${var.compartment_ocid}"

  statements = ["Allow group ${oci_identity_group.DBAdmins.name} to manage database-family in compartment ${var.compartment_name}",
    "Allow group ${oci_identity_group.DBAdmins.name} to use virtual-network-family in compartment ${var.compartment_name}",
  ]
}

resource "oci_identity_group" "AppDevs" {
  name        = "AppDevs"
  description = "group created for App Devs"
}

resource "oci_identity_policy" "policy-AppDevs" {
  name           = "policy-AppDevs"
  description    = "policy created for App devs"
  compartment_id = "${var.compartment_ocid}"

  statements = ["Allow group ${oci_identity_group.AppDevs.name} to manage instance-family in compartment ${var.compartment_name}",
    "Allow group ${oci_identity_group.AppDevs.name} to use virtual-network-family in compartment ${var.compartment_name}",
  ]
}
