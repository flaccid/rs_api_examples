#! /bin/sh -e

# Warning: This script scrapes information from the RightScale dashboard (portal).  Do not use this script for production or any important purposes.  RightScale cannot guarantee this script to work now or in the future.

# rs-refetch-cookbook-repo.sh <cookbook_repos_id>

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
