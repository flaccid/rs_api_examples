#! /bin/sh -e

# rs-get-array-instances-dash-html.sh <server_array_id>

# Warning: This script scrapes information from the RightScale dashboard.
# It is not recommended to use this script for production purposes. RightScale cannot guarantee this script will work now or in the future.

# Notes: returns only the raw html doc (intended for demo only)
#        currently only supports non-EC2 arrays.

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[ ! "$1" ] && echo 'No server array ID provided.' && exit 1

server_array_id="$1"

array_instances_html=$(curl -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
	--referer "Referer:https://my.rightscale.com/acct/$rs_api_account_id/server_arrays/$server_array_id/instances" \
	-H "X-Requested-With: XMLHttpRequest" \
	"https://my.rightscale.com/acct/$rs_api_account_id/server_arrays/$server_array_id/instances#tab_instances_panel")

echo "$array_instances_html"

case $api_result in
	*"200 OK"*)
		echo "$array_instances_html"
	;;
	*)
		echo "$array_instances_html"
		echo "FAIL!"
		exit 1
	;;
esac