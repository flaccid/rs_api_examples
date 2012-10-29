#! /bin/bash -e

# rs-create-server-dash.sh <nickname> <rs_cloud_id> <deployment_id> <server_template_id> <ec2_instance_type> <ec2_pricing> <nat_enabled> <ec2_ssh_key_id> <vpc_subnet_id>
# e.g. rs-create-server-dash.sh 'Starbug' 4 281233001 252761001 't1.micro' 'on_demand' 0 209585 201548001

# Warning: This script posts information to the RightScale dashboard (portal).
# Do not use this script for production or any important purposes.  RightScale cannot guarantee this script to work now or in the future.

# RightScale (public) cloud IDs
#1  US-East
#2  Europe
#3  US-West
#4  Singapore 
#5  Tokyo
#6  Oregon
#7  SA-São Paulo (Brazil)

# Example params:
# server_template_id:252761001
# runnable[nickname]:RightScale Linux Server RL 5.8
# runnable[multi_cloud_image_id]:
# runnable[instance_type]:
# runnable[pricing]:on_demand
# runnable[max_spot_price]:0.025
# runnable[vpc_subnet_id]:
# runnable[private_ip_address]:
# runnable[nat_enabled]:0
# runnable[ec2_ssh_key_id]:298336
# runnable[ec2_elastic_ip_id]:
# runnable[associate_eip_at_launch]:0
# runnable[associate_eip_at_launch]:1
# runnable[ec2_security_group_ids][]:261902
# runnable[ec2_security_group_ids][]:261903
# runnable[ec2_availability_zone_id]:
# runnable[ec2_placement_group_id]:
# runnable[image_uid]:
# runnable[ari_image_uid]:
# runnable[aki_image_uid]:
# runnable[ec2_user_data]:
# cloud_id:4
# runnable[server_template_id]:252761001
# runnable[deployment_id]:28079
# runnable[ebs_obtimized]:1

[[ ! $1 ]] && echo 'No Server nickname ID provided.' && exit 1
[[ ! $2 ]] && echo 'No RightScale cloud ID provided.' && exit 1
[[ ! $3 ]] && echo 'No RightScale deployment ID provided.' && exit 1
[[ ! $4 ]] && echo 'No RightScale ServerTemplate ID provided.' && exit 1
[[ ! $5 ]] && echo 'No EC2 instance type provided.' && exit 1
[[ ! $6 ]] && echo 'No EC2 pricing type provided.' && exit 1
[[ ! $7 ]] && echo 'No NAT enabled option provided.' && exit 1
[[ ! $8 ]] && echo 'No EC2 SSH key ID provided.' && exit 1
[[ ! $9 ]] && echo 'No VPC subnet ID provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

nickname="$1"
rs_cloud_id="$2"
deployment_id="$3"
server_template_id="$4"
ec2_instance_type="$5"
ec2_pricing="$6"
nat_enabled="$7"
ec2_ssh_key_id="$8"
vpc_subnet_id="$9"

ec2_security_group_ids=""
ec2_elastic_ip_id=""
ebs_optimized=0
ari_image_uid=""
aki_image_uid=""
ec2_user_data=""
image_uid=""
multi_cloud_image_id=""
ec2_availability_zone_id=""
max_spot_price="0.025"
ec2_placement_group_id=""

runnable__ec2_security_group_ids_str=
for f in ${runnable__ec2_security_group_ids[*]}
do
echo "[$f]"
   runnable__ec2_security_group_ids_str="-d runnable[ec2_security_group_ids]=$f $runnable__ec2_security_group_ids_str"
echo "[$runnable__ec2_security_group_ids_str]"
done

#rs-login-dashboard.sh               # (run this first to ensure current session)

url="https://my.rightscale.com/acct/$rs_api_account_id/servers"
echo "POST: $url"

result=$(curl -v -S -s -X POST \
-b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
-H "Referer:https://my.rightscale.com/acct/$rs_api_account_id/servers/new?cloud_id=$rs_cloud_id&deployment_id=$deployment_id" \
-H "User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1" \
-H "X-Prototype-Version:1.6.1" \
-H "X-Requested-With:XMLHttpRequest" \
-d server_template_id="$server_template_id" \
-d runnable[nickname]="$nickname" \
-d runnable[multi_cloud_image_id]="$multi_cloud_image_id" \
-d runnable[instance_type]="$ec2_instance_type" \
-d runnable[pricing]="$ec2_pricing" \
-d runnable[max_spot_price]="$max_spot_price" \
-d runnable[vpc_subnet_id]="$vpc_subnet_id" \
-d runnable[nat_enabled]="$nat_enabled" \
-d runnable[ec2_ssh_key_id]="$ec2_ssh_key_id" \
-d runnable[ec2_elastic_ip_id]="$ec2_elastic_ip_id" \
-d runnable[associate_eip_at_launch]="0" \
-d runnable[ec2_security_group_ids][]="$ec2_security_group_ids" \
-d runnable[ec2_availability_zone_id]="$ec2_availability_zone_id" \
-d runnable[ec2_placement_group_id]="$ec2_placement_group_id" \
-d runnable[image_uid]="$image_uid" \
-d cloud_id="$rs_cloud_id" \
-d runnable[server_template_id]="$server_template_id" \
-d runnable[associate_eip_at_launch]="0" \
-d runnable[associate_eip_at_launch]="1" \
-d runnable[deployment_id]="$deployment_id" \
-d stage_names[]="ServerTemplate" \
-d stage_names[]="Server Details" \
-d stage_names[]="Confirm" \
-d runnable[image_uid]="$image_uid" \
-d runnable[ari_image_uid]="$ari_image_uid" \
-d runnable[aki_image_uid]="$aki_image_uid" \
-d runnable[ec2_user_data]="$ec2_user_data" \
-d runnable[ebs_optimized]="$ebs_optimized" \
-d _=" " \
"$url" 2>&1)

case $result in
	*redirect_url*)
		echo 'Server successfully created.'
		echo "$result" | tail -n 1
	;;
	*errors*)
		echo 'Server creation failed!'
		echo "$result"
		exit 1
	;;
esac