#! /bin/sh -e

# Warning: This script posts information to the RightScale dashboard.
# Do not use this script for production or any important purposes.  RightScale cannot guarantee this script to work now or in the future.

# rs-query-cloud.sh <rs_cloud_id>

# RightScale (public) cloud IDs
#1  US-East
#2  Europe
#3  US-West
#4  Singapore 
#5  Tokyo
#6  Oregon
#7  SA-São Paulo (Brazil)

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[ ! "$1" ] && echo 'No RightScale cloud ID provided.' && exit 1

rs_cloud_id="$1"

api_url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/ec2_instances/requery"
echo "[dashboard] POST: $api_url"

api_result=$(curl -X POST -v -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" -d "_method=put" --referer "https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/ec2_instances" "$api_url" 2>&1)

# should equal referer
echo "$api_result" | grep "Location: " | awk '{ print $3 }'