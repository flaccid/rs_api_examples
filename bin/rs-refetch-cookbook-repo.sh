#! /bin/sh -e

# rs-refetch-cookbook-repo.sh <cookbook_repos_id>

# Warning: This script sends a request to the RightScale dashboard.
# It is not recommended to use this script for production purposes. RightScale cannot guarantee this script will work now or in the future.

[[ ! $1 ]] && echo 'No cookbooks_repos ID provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

#rs-login-dashboard.sh (run this first to ensure current session)

url="https://my.rightscale.com/acct/$rs_api_account_id/cookbook_repos/$1/update_metadata"
echo "GET: $url"

result=$(curl -v -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" -X PUT -d _=" " "$url" 2>&1)

case $result in
	*"200 OK"*)
		echo "Re-fetch of $1 successfuly initiated."
	;;
	*)
		echo "$result"
		echo "Re-fetch of $1 failed!"
	;;
esac