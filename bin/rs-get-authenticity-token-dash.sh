#! /bin/bash -e

# rs-get-authenticity-token-dash.sh <server_id> [[debug]]

# Warning: This script scrapes information from the RightScale dashboard.
# It is not recommended to use this script for production purposes. RightScale cannot guarantee this script will work now or in the future.

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

#rs-login-dashboard.sh               # (run this first to ensure current session)

[[ ! $1 ]] && echo 'No Server ID provided.' && exit 1

rs_server_id="$1"

url="https://$rs_server/acct/$rs_api_account_id/servers/$rs_server_id/info;edit?next_server=true"
if [ "$2" == 'debug' ]; then
	echo "GET: $url"
fi

result=$(curl -v -S -s -b "$HOME/.rightscale/rs_dashboard_cookie.txt" "$url" 2>&1)

echo "$result" | grep 'authenticity_token' | sed "s/.* value=\"\(.*\)\".*/\1/" | tail -n1 | tr '\n' ' '