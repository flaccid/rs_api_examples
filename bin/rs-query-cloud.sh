#! /bin/sh -e

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

#url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/ec2_instances/requery"
url="https://my.rightscale.com/acct/$rs_api_account_id/dashboard;overview"

result=$(curl -v -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" "$url" 2>&1)
#curl -s -c -b "$HOME/.rightscale/rs_dashboard_cookie.txt" -u "$rs_api_user":"$rs_api_password" "$url"

case $result in
	*"200 OK"*)
		echo "Cloud '$rs_cloud_id' successfuly re-queried."
	;;
	*)
		echo "$result"
		echo "Re-query of cloud '$rs_cloud_id' failed!"
	;;
esac
