#     ___  ____     _    ____ _     _____
#    / _ \|  _ \   / \  / ___| |   | ____|
#   | | | | |_) | / _ \| |   | |   |  _|
#   | |_| |  _ < / ___ | |___| |___| |___
#    \___/|_| \_/_/   \_\____|_____|_____|

Memcached Infrastructure

This configuration generally implements this - 

This script creates a typical 3 tiered app with a public Load balancer pair in 2 public subnets, app servers in 2 private subnets, memcached servers in 2 private subnets and Mysql DB servers in private subnets, across two Availability Domains. It also creates a VCN with a route table, Internet Gateway, Security Lists, a bastion subnet.

Using this example

    Update env-vars with the required information. Most examples use the same set of environment variables so you only need to do this once.
    Source env-vars
        $ . env-vars
    Update variables.tf with your instance options.

Files in the configuration
env-vars

Is used to export the environmental variables used in the configuration. These are usually authentication related, be sure to exclude this file from your version control system. It's typical to keep this file outside of the configuration.

Before you plan, apply, or destroy the configuration source the file -
$ . env-vars
compute.tf

Defines the compute resource
remote-exec.tf

Uses a null_resource, remote-exec and depends_on to execute a command on the instance. More information on the remote-exec provisioner.
./userdata/*

The user-data scripts that get injected into an instance on launch. More information on user-data scripts can be found at the cloud-init project.
variables.tf

Defines the variables used in the configuration
datasources.tf

Defines the datasources used in the configuration
outputs.tf

Defines the outputs of the configuration
provider.tf

Specifies and passes authentication details to the OCI TF provider
