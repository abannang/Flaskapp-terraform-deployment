resource "oci_core_instance" "AppAD1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "AppAD1"
  image               = "${var.InstanceImageOCID[var.region]}"
  shape               = "${var.AppShape}"
  subnet_id           = "${oci_core_subnet.PublicSubnetAD1.id}"

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(var.user-data)}"
  }

  # defined_tags = "${
  #   map(
  #     "${oci_identity_tag_namespace.AppDevs.name}.${oci_identity_tag.Project.name}", "NameMesh-App"
  #   )
  # }"
}

resource "oci_core_instance" "AppAD2" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "AppAD2"
  image               = "${var.InstanceImageOCID[var.region]}"
  shape               = "${var.AppShape}"
  subnet_id           = "${oci_core_subnet.PublicSubnetAD2.id}"

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(var.user-data)}"
  }

  # defined_tags = "${
  #   map(
  #     "${oci_identity_tag_namespace.AppDevs.name}.${oci_identity_tag.Project.name}", "NameMesh-App"
  #   )
  # }"
}

variable "user-data" {
  default = <<EOF
#!/bin/bash -x

touch start1
touch ~/start2
touch /root/start3 

echo '################### webserver userdata begins #####################'
touch ~opc/userdata.`date +%s`.start

# echo '########## yum update all ###############'
# yum update -y
# sudo apt-get update

echo '########## basic webserver ##############'
#yum install -y httpd
sudo apt-get -y install apache2

#systemctl enable httpd.service
systemctl enable apache2.service
#systemctl start  httpd.service
systemctl start  apache2.service

echo '<html><head></head><body><pre><code>' > /var/www/html/index.html

hostname >> /var/www/html/index.html

echo '' >> /var/www/html/index.html

cat /etc/os-release >> /var/www/html/index.html

echo '<p>' >> /var/www/html/index.html

ip addr show >> /var/www/html/index.html 2>&1

echo '<p>' >> /var/www/html/index.html

curl ifconfig.co >> /var/www/html/index.html

ifconfig -a | grep -ie flags -ie netmask >> /var/www/html/index.html

echo '<p>' >> /var/www/html/index.html

curl ifconfig.co >> /var/www/html/index.html

echo '</code></pre></body></html>' >> /var/www/html/index.html

#firewall-offline-cmd --add-service=http
#systemctl enable  firewalld
#systemctl restart  firewalld


touch ~opc/userdata.`date +%s`.finish
echo '################### webserver userdata ends #######################'


#################################################################

apt-get -y install git

cd ~

git clone https://github.com/abannang/3-tier-HA-Python-Flask-App

cd 3-tier-HA-Python-Flask-App

chmod a+rx *.sh
#./update.sh

sudo apt-get update -y
sudo apt-get install python-pip python-dev build-essential -y
sudo pip install -r ~/3-tier-HA-Python-Flask-App/requirements.txt
sudo apt-get install unzip -y

#./oracle-config.sh
sudo mkdir /opt/oracle

wget https://objectstorage.us-phoenix-1.oraclecloud.com/n/bhowesint1/b/oraleinstantclientbasiclinuxx64/o/instantclient-basic-linux.x64-12.2.0.1.0.zip 

sudo unzip instantclient-basic-linux.x64-12.2.0.1.0.zip -d /opt/oracle/
sudo ln -s /opt/oracle/instantclient_12_2/libclntsh.so.12.1 libclntsh.so
sudo ln -s /opt/oracle/instantclient_12_2/libocci.so.12.1 libocci.so
sudo apt-get install libaio1 -y
sudo sh -c "echo /opt/oracle/instantclient_12_2 > /etc/ld.so.conf.d/oracle-instantclient.conf"
sudo ldconfig


#./firewall-config.sh
##sudo apt-get install firewalld -y
##sudo firewall-cmd --permanent --add-port=5000/tcp
##sudo firewall-cmd --reload

/sbin/iptables -I INPUT 2 -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
/sbin/iptables -I INPUT 2 -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
/sbin/iptables -I INPUT 2 -p tcp -m state --state NEW -m tcp --dport 1521 -j ACCEPT
/sbin/iptables -I INPUT 2 -p tcp -m state --state NEW -m tcp --dport 5000 -j ACCEPT

/bin/sed  -i '/-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT/a-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT \n-A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT \n-A INPUT -p tcp -m state --state NEW -m tcp --dport 1521 -j ACCEPT\n-A INPUT -p tcp -m state --state NEW -m tcp --dport 5000 -j ACCEPT\n' /etc/iptables/rules.v4

sudo apt-get -y install screen

chmod a+rx main.py

screen -dm python ./main.py

touch ~/done1
touch /root/done2

EOF
}

# resource "oci_core_instance" "MemcachedAD1" {
#   availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
#   compartment_id      = "${var.compartment_ocid}"
#   display_name        = "MemcachedAD1"
#   image               = "${var.InstanceImageOCID[var.region]}"
#   shape               = "${var.MemcachedShape}"
#   subnet_id           = "${oci_core_subnet.PrivSubnet2AD1.id}"

#   metadata {
#     ssh_authorized_keys = "${var.ssh_public_key}"
#     user_data           = "${base64encode(file(var.MemcachedBootStrap))}"
#   }
# }

# resource "oci_core_instance" "MemcachedAD2" {
#   availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
#   compartment_id      = "${var.compartment_ocid}"
#   display_name        = "MemcachedAD2"
#   image               = "${var.InstanceImageOCID[var.region]}"
#   shape               = "${var.MemcachedShape}"
#   subnet_id           = "${oci_core_subnet.PrivSubnet2AD2.id}"

#   metadata {
#     ssh_authorized_keys = "${var.ssh_public_key}"
#     user_data           = "${base64encode(file(var.MemcachedBootStrap))}"
#   }
# }

# resource "oci_core_instance" "MysqlDBAD1" {
#   availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
#   compartment_id      = "${var.compartment_ocid}"
#   display_name        = "MysqlDBAD1"
#   image               = "${var.InstanceImageOCID[var.region]}"
#   shape               = "${var.MysqlDBShape}"
#   subnet_id           = "${oci_core_subnet.PrivSubnet3AD1.id}"

#   metadata {
#     ssh_authorized_keys = "${var.ssh_public_key}"
#     user_data           = "${base64encode(file(var.MysqlDBBootStrap))}"
#   }

#   timeouts {
#     create = "30m"
#   }
# }

# resource "oci_core_instance" "MysqlDBAD2" {
#   availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
#   compartment_id      = "${var.compartment_ocid}"
#   display_name        = "MysqlDBAD2"
#   image               = "${var.InstanceImageOCID[var.region]}"
#   shape               = "${var.MysqlDBShape}"
#   subnet_id           = "${oci_core_subnet.PrivSubnet3AD2.id}"

#   metadata {
#     ssh_authorized_keys = "${var.ssh_public_key}"
#     user_data           = "${base64encode(file(var.MysqlDBBootStrap))}"
#   }

#   timeouts {
#     create = "30m"
#   }
# }

/* Load Balancer */

resource "oci_load_balancer" "PubLB" {
  shape          = "100Mbps"
  compartment_id = "${var.compartment_ocid}"

  subnet_ids = [
    "${oci_core_subnet.PublicSubnetAD1.id}",
    "${oci_core_subnet.PublicSubnetAD2.id}",
  ]

  display_name = "PubLB"
}

resource "oci_load_balancer_backendset" "lb-bes1" {
  name             = "lb-bes1"
  load_balancer_id = "${oci_load_balancer.PubLB.id}"
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "5000"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_certificate" "lb-cert1" {
  load_balancer_id = "${oci_load_balancer.PubLB.id}"

  ca_certificate     = "-----BEGIN CERTIFICATE-----\nMIIBNzCB4gIJAKtwJkxUgNpzMA0GCSqGSIb3DQEBCwUAMCMxITAfBgNVBAoTGElu\ndGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0xNzA0MTIyMTU3NTZaFw0xODA0MTIy\nMTU3NTZaMCMxITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDBcMA0G\nCSqGSIb3DQEBAQUAA0sAMEgCQQDlM8lz3BFJA6zBlsF63k9ajPVq3Q1WQoHQ3j35\n08DRKIfwqfV+CxL63W3dZrwL4TrjqorP5CQ36+I6OWALH2zVAgMBAAEwDQYJKoZI\nhvcNAQELBQADQQCEjHVQJoiiVpIIvDWF+4YDRReVuwzrvq2xduWw7CIsDWlYuGZT\nQKVY6tnTy2XpoUk0fqUvMB/M2HGQ1WqZGHs6\n-----END CERTIFICATE-----"
  certificate_name   = "certificate1"
  private_key        = "-----BEGIN RSA PRIVATE KEY-----\nMIIBOgIBAAJBAOUzyXPcEUkDrMGWwXreT1qM9WrdDVZCgdDePfnTwNEoh/Cp9X4L\nEvrdbd1mvAvhOuOqis/kJDfr4jo5YAsfbNUCAwEAAQJAJz8k4bfvJceBT2zXGIj0\noZa9d1z+qaSdwfwsNJkzzRyGkj/j8yv5FV7KNdSfsBbStlcuxUm4i9o5LXhIA+iQ\ngQIhAPzStAN8+Rz3dWKTjRWuCfy+Pwcmyjl3pkMPSiXzgSJlAiEA6BUZWHP0b542\nu8AizBT3b3xKr1AH2nkIx9OHq7F/QbECIHzqqpDypa8/QVuUZegpVrvvT/r7mn1s\nddS6cDtyJgLVAiEA1Z5OFQeuL2sekBRbMyP9WOW7zMBKakLL3TqL/3JCYxECIAkG\nl96uo1MjK/66X5zQXBG7F2DN2CbcYEz0r3c3vvfq\n-----END RSA PRIVATE KEY-----"
  public_certificate = "-----BEGIN CERTIFICATE-----\nMIIBNzCB4gIJAKtwJkxUgNpzMA0GCSqGSIb3DQEBCwUAMCMxITAfBgNVBAoTGElu\ndGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0xNzA0MTIyMTU3NTZaFw0xODA0MTIy\nMTU3NTZaMCMxITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDBcMA0G\nCSqGSIb3DQEBAQUAA0sAMEgCQQDlM8lz3BFJA6zBlsF63k9ajPVq3Q1WQoHQ3j35\n08DRKIfwqfV+CxL63W3dZrwL4TrjqorP5CQ36+I6OWALH2zVAgMBAAEwDQYJKoZI\nhvcNAQELBQADQQCEjHVQJoiiVpIIvDWF+4YDRReVuwzrvq2xduWw7CIsDWlYuGZT\nQKVY6tnTy2XpoUk0fqUvMB/M2HGQ1WqZGHs6\n-----END CERTIFICATE-----"
}

resource "oci_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = "${oci_load_balancer.PubLB.id}"
  name                     = "http"
  default_backend_set_name = "${oci_load_balancer_backendset.lb-bes1.id}"
  port                     = 80
  protocol                 = "HTTP"
}

# resource "oci_load_balancer_listener" "lb-listener2" {
#   load_balancer_id         = "${oci_load_balancer.PubLB.id}"
#   name                     = "https"
#   default_backend_set_name = "${oci_load_balancer_backendset.lb-bes1.id}"
#   port                     = 443
#   protocol                 = "HTTP"

#   ssl_configuration {
#     certificate_name        = "${oci_load_balancer_certificate.lb-cert1.certificate_name}"
#     verify_peer_certificate = false
#   }
# }

resource "oci_load_balancer_backend" "lb-be1" {
  load_balancer_id = "${oci_load_balancer.PubLB.id}"
  backendset_name  = "${oci_load_balancer_backendset.lb-bes1.id}"
  ip_address       = "${oci_core_instance.AppAD1.private_ip}"
  port             = 5000
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend" "lb-be2" {
  load_balancer_id = "${oci_load_balancer.PubLB.id}"
  backendset_name  = "${oci_load_balancer_backendset.lb-bes1.id}"
  ip_address       = "${oci_core_instance.AppAD2.private_ip}"
  port             = 5000
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}
