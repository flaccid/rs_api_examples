#!/bin/sh -e

# rs-update-server.sh

# TODO: this is currently unfinished

# RightScale (public) cloud IDs
#1  US-East
#2  Europe
#3  US-West
#4  Singapore 
#5  Tokyo
#6  Oregon
#7  SA-São Paulo (Brazil)

[[ ! $1 ]] && echo 'No Server nickname ID provided.' && exit 1
[[ ! $2 ]] && echo 'No RightScale cloud ID provided.' && exit 1
[[ ! $3 ]] && echo 'No RightScale deployment href provided.' && exit 1
[[ ! $4 ]] && echo 'No RightScale ServerTemplate href provided.' && exit 1
[[ ! $5 ]] && echo 'No EC2 instance type provided.' && exit 1
[[ ! $6 ]] && echo 'No EC2 pricing type provided.' && exit 1
[[ ! $7 ]] && echo 'No EC2 SSH key href provided.' && exit 1
[[ ! $8 ]] && echo 'No EC2 security group provided.' && exit 1
#[[ ! $9 ]] && echo 'No EC2 optmized option provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

nickname="$1"
rs_cloud_id="$2"
deployment_href="$3"
server_template_href="$4"
ec2_instance_type="$5"
ec2_pricing="$6"
ec2_ssh_key_href="$7"
ec2_security_groups_href="$8"
ec2_ebs_optimized="$9"
: ${ec2_ebs_optimized:=0}

url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers"
echo "POST: $url"

# Parameters:
# server[nickname]: Nickname of the server
# server[server_template_href]: href of the ServerTemplate
# server[ec2_ssh_key_href]: href of the SSH Key, optional. Required to start server.
# server[ec2_security_groups_href]: Array of security_group hrefs, optional. Required to start server. Cannot be used in conjunction with the parameter vpc_subnet_href.
# server[deployment_href]: href of the deployment
# server[aki_image_href]: href of the AKI image
# server[ari_image_href]: href of the ARI image
# server[ec2_image_href]: href of the AMI image
# server[multi_cloud_image_href]: href of the MCI, optional. server[server_template_href] parameter should be set when passing this parameter.
# server[vpc_subnet_href]: href of the vpc subnet
# server[instance_type]: AWS instance type
# server[ec2_user_data]: User data
# server[ec2_elastic_ip_href]: URL to the elastic ip
# server[associate_eip_at_launch]: associate elastic IP at launch (0 or 1)
# server[ec2_availability_zone]: Ec2 availability zone (ex: us-east-1a). Cannot be used in conjunction with the parameter vpc_subnet_href.
# server[pricing]: server’s pricing type - ‘on_demand’ or ‘spot’. If unspecified, the default value is ‘on_demand’
# server[max_spot_price]: the maximum price(in $/hour) you will pay for the spot instance.
# server[ebs_optimized]: whether instances created should be Amazon EBS optimized instances which support IOPS provisioned on an EBS volume, optional. Valid values are ‘true’ or ‘false’ (default).
# cloud_id : Id of the cloud in which the server should be created, optional

