#!/bin/sh -e

# rs-create-server-cs.sh <rs_cloud_id> <deployment_id> <server_template_id> <server_nickname> <mci_id> <instance_type_resource_id> <security_group_resource_ids> <datacenter_resource_id> <subnet_resource_ids>

# e.g. rs-create-server-cs.sh 2365 309357001 273511001 "i did this from curl" 277375001 FRA04CD0FVQD C3UAOU9DAB6KM 2M6PGCI3RJ7EM EOGJ4VM1M5CB8

# Warning: This script posts information to the RightScale dashboard.
# It is not recommended to use this script for production purposes. RightScale cannot guarantee this script will work now or in the future.

# form data example
#server_template_id:273511001
#runnable[id]:
#runnable[nickname]:Base ServerTemplate for Linux (RSB)  (v13.1.1)
#runnable[multi_cloud_image_id]:277375001
#runnable[instance_type_rsid]:FRA04CD0FVQD
#runnable[security_group_rsids][]:C3UAOU9DAB6KM
#runnable[datacenter_rsid]:2M6PGCI3RJ7EM
#runnable[recurring_subnet_rsids][]:EOGJ4VM1M5CB8
#runnable[image_uid]:
#runnable[user_user_data]:
#cloud_id:2365
#runnable[server_template_id]:273511001
#runnable[deployment_id]:309357001
#stage_names[]:ServerTemplate
#stage_names[]:Server Details
#stage_names[]:Confirm

[ ! "$1" ] && echo 'No RightScale cloud ID provided.' && exit 1
[ ! "$2" ] && echo 'No deployment ID provided.' && exit 1
[ ! "$3" ] && echo 'No ServerTemplate ID provided.' && exit 1
[ ! "$4" ] && echo 'No Server nickname provided.' && exit 1
[ ! "$5" ] && echo 'No MCI ID provided.' && exit 1
[ ! "$6" ] && echo 'No instance type resource ID provided.' && exit 1
[ ! "$7" ] && echo 'No security group resource ID provided.' && exit 1
[ ! "$8" ] && echo 'No datacenter resource ID provided.' && exit 1
[ ! "$9" ] && echo 'No subnet resource ID(s) provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_cloud_id="$1"
deployment_id="$2"
server_template_id="$3"
server_nickname="$4"
mci_id="$5"
instance_type_resource_id="$6"
security_group_resource_ids="$7"
datacenter_resource_id="$8"
subnet_resource_ids="$9"

api_url="https://my.rightscale.com/acct/$rs_api_account_id/servers"
echo "[dashboard] POST: $api_url"

api_result=$(curl -X POST -v -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" --referer "https://my.rightscale.com/acct/51685/servers/new?cloud_id=$rs_cloud_id&deployment_id=$deployment_id" \
	-H "X-Requested-With:XMLHttpRequest" \
	-d "runnable[id]=" \
	-d "runnable[image_uid]=" \
	-d "runnable[user_user_data]=" \
	-d "stage_names[]=ServerTemplate" \
	-d "stage_names[]=Server Details" \
	-d "stage_names[]=Confirm" \
	-d "server_template_id=$server_template_id" \
	-d "runnable[nickname]=$server_nickname" \
	-d "runnable[multi_cloud_image_id]=$mci_id" \
	-d "runnable[instance_type_rsid]=$instance_type_resource_id" \
	-d "runnable[security_group_rsids][]=$security_group_resource_ids" \
	-d "runnable[datacenter_rsid]=$datacenter_resource_ids" \
	-d "runnable[recurring_subnet_rsids][]=$subnet_resource_ids" \
	-d "cloud_id=$rs_cloud_id" \
	-d "runnable[server_template_id]=$server_template_id" \
	-d "runnable[deployment_id]=$deployment_id" \
 	"$api_url" 2>&1)

case $api_result in
	*"200 OK"*)
		echo "Server, '$server_nickname' successfully created."
		echo "$api_result" | grep redirect_url
	;;
	*)
		echo "$api_result"
		echo "Creation of server, '$server_nickname' failed!"
		exit 1
	;;
esac