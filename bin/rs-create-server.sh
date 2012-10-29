#! /bin/bash -e

# rs-create-server.sh <nickname> <rs_cloud_id> <deployment_href> <server_template_href> <ec2_instance_type> <ec2_pricing> <ec2_ssh_key_href> <ec2_security_group_hrefs> <e2_ebs_optimized>
# e.g. rs-create-server.sh 'Starbug' 3 "https://my.rightscale.com/api/acct/7954/deployments/49302" "https://my.rightscale.com/api/acct/7954/server_templates/262048001" 't1.micro' 'on_demand' "https://my.rightscale.com/acct/7954/clouds/3/ec2_ssh_keys/182526" "https://my.rightscale.com/acct/7954/clouds/3/ec2_security_groups/106112" 1

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

result=$(curl -v -S -s -X POST \
-H X-API-VERSION:"$rs_api_version" \
-b "$HOME/.rightscale/rs_api_cookie.txt" \
-d server[nickname]="$nickname" \
-d server[server_template_href]="$server_template_href" \
-d server[deployment_href]="$deployment_href" \
-d server[instance_type]="$ec2_instance_type" \
-d server[pricing]="$ec2_pricing" \
-d server[ec2_ssh_key_href]="$ec2_ssh_key_href" \
-d server[ec2_security_groups_href][]="$ec2_security_groups_href" \
-d server[ebs_optimized]="$ec2_ebs_optimized" \
-d cloud_id="$rs_cloud_id" \
"$url" 2>&1)

# other possible params
#-d server[ec2_availability_zone]="$ec2_availability_zone"
#-d server[aki_image_href]="$aki_image_href"
#-d server[ari_image_href]="$ari_image_href"
#-d server[ec2_image_href]="$ec2_image_href"
#-d server[multi_cloud_image_href]="$multi_cloud_image_href"
#-d server[ec2_user_data]="$ec2_user_data"
#-d server[ec2_elastic_ip_href]="$ec2_elastic_ip_href"
#-d server[associate_eip_at_launch]="$associate_eip_at_launch"
#-d server[max_spot_price]="$ec2_max_spot_price"

case $result in
	*'201 Created'*)
		echo 'Server successfully created.'
		echo "$result" | grep Location | awk '/Location:/ { print $3 }'
		exit
	;;
	*)
		echo 'Server creation failed!'
		echo "$result"
		exit 1
	;;
esac