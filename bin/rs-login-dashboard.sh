#! /bin/sh -e

# Warning: This script scrapes information from the RightScale dashboard (portal).  Do not use this script for production or any important purposes.  RightScale cannot guarantee this script to work now or in the future.

# rs-login-dashboard.sh

[ -e "$HOME"/rightscale ] || ( mkdir -p "$HOME"/rightscale && chmod -R 700 "$HOME"/.rightscale )

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

# Login to the dashboard non-interactively
url="https://my.rightscale.com/session"
echo "GET: $url"

result=$(curl -v -s -S -c "$HOME/.rightscale/rs_dashboard_cookie.txt" -u "$rs_api_user:$rs_api_password" -d account="$rs_api_account_id" -X PUT "$url" 2>&1)

case $result in
	*"dashboard;overview"*)
		echo 'Login successful.'
	;;
	*)
		echo "$result"
		echo 'Login failed!'
	;;
esac
