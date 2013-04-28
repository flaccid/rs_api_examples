#! /bin/sh -e

# Warning: This script posts information to the RightScale dashboard.
# Do not use this script for production or any important purposes.  RightScale cannot guarantee this script to work now or in the future.

# rs-set-vpc-subnet-server.sh <rs_server_id> <rs_vpc_subnet_id>

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[ ! "$1" ] && echo 'No RightScale server ID provided.' && exit 1
[ ! "$2" ] && echo 'No VPC subnet ID provided.' && exit 1

server_id="$1"
vpc_subnet_id="$1"

api_url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/ec2_instances/requery"
echo "[dashboard] POST: $api_url"

api_result=$(curl -X POST -v -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" -d "_method=put" --referer "https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/ec2_instances" "$api_url" 2>&1)

# should equal referer
echo "$api_result" | grep "Location: " | awk '{ print $3 }'