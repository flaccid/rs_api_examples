#!/bin/sh -e

# rs-update-server-security-group-dash.sh <server_id> <ec2_security_group_id> <deployment_id> [[debug]]

# e.g. rs-update-server-security-group-dash.sh 256652022 285049011

[ ! "$1" ] && echo 'No server ID provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_server_id="$1"
ec2_security_group_id="$2"
deployment_id="$3"

authenticity_token=$(./rs-get-authenticity-token-dash.sh $1)

if [ "$4" == 'debug' ]; then
	echo "Authenticity token: $authenticity_token"
fi

url="https://$rs_server/acct/$rs_api_account_id/servers/$rs_server_id/info?next_server=true"
echo "POST: $url"

result=$(curl -v -S -s -X POST \
-b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
-H "Content-Type:application/x-www-form-urlencoded; charset=UTF-8" \
-H "Host:$rs_server" \
-H "Origin:https://$rs_server" \
-H "Referer:https://$rs_server/acct/$rs_api_account_id/servers/$rs_server_id/info;edit" \
-H "X-Requested-With:XMLHttpRequest" \
-d next_server="true" \
-d runnable[server_template_id]=213739008 \
-d runnable[deployment_id]="$deployment_id" \
-d id="$rs_server_id" \
-d stage_names[]='ServerTemplate' \
-d stage_names[]='Server Details' \
-d stage_names[]='Confirm' \
-d _method='put' \
-d cloud_id=8 \
-d server_template_id=213739008 \
-d authenticity_token="$authenticity_token" \
-d runnable[nickname]='VPC Create Test' \
-d runnable[instance_type]='t1.micro' \
-d runnable[pricing]='on_demand' \
-d runnable[max_spot_price]='0.02' \
-d runnable[ebs_optimized]=0 \
-d runnable[vpc_subnet_id]=200291008 \
-d runnable[nat_enabled]=0 \
-d runnable[ec2_ssh_key_id]=231678008 \
-d runnable[associate_eip_at_launch]=0 \
-d runnable[associate_eip_at_launch]=1 \
-d runnable[ec2_security_group_ids][]="$ec2_security_group_id" \
-d runnable[ec2_elastic_ip_id]='' \
-d runnable[placement_tenancy]='' \
-d runnable[private_ip_address]='' \
-d runnable[multi_cloud_image_id]='' \
-d runnable[image_uid]='' \
-d runnable[ari_image_uid]='' \
-d runnable[aki_image_uid]='' \
-d runnable[ec2_user_data]='' \
-d runnable[ec2_availability_zone_id]= '' \
-d runnable[ec2_placement_group_id]='' \
"$url" 2>&1)

echo "$result"