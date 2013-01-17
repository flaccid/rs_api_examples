#! /bin/sh -e

# Warning: This script posts information to the RightScale dashboard.
# Do not use this script for production or any important purposes.  RightScale cannot guarantee this script to work now or in the future.

# rs-rename-array-instance.sh <rs_cloud_id> <array_instance_id> <new_instance_name>

# Note: currently only supports non-EC2 arrays.

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[ ! "$1" ] && echo 'No RightScale cloud ID provided.' && exit 1
[ ! "$2" ] && echo 'No array instance ID provided.' && exit 1
[ ! "$3" ] && echo 'No instance name provided.' && exit 1

rs_cloud_id="$1"
array_instance_id="$2"
new_instance_name="$3"

api_url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/instances/$array_instance_id/set_instance_name"

echo "[dashboard] POST: $api_url"

api_result=$(curl -X POST -v -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" -H "X-Requested-With: XMLHttpRequest" -d "name=$new_instance_name" "$api_url" 2>&1)

case $api_result in
	*"200 OK"*)
		echo "Server array instance, $array_instance_id successfuly renamed as '$new_instance_name'."
	;;
	*)
		echo "$api_result"
		echo "Server array instance rename failed!"
	;;
esac