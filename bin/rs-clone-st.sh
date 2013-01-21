#!/bin/sh -e

# rs-clone-st.sh <server_template_id>

# Warning: This script posts information to the RightScale dashboard.
# It is not recommended to use this script for production purposes. RightScale cannot guarantee this script will work now or in the future.

[ ! "$1" ] && echo 'No server_template_id ID provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

url="https://my.rightscale.com/acct/$rs_api_account_id/server_templates/$1/duplicate"		# /acct/1/server_templates/1/duplicate
echo "PUT: $url"

api_result=$(curl -s -S -i -b "$HOME/.rightscale/rs_dashboard_cookie.txt" -X PUT -d _=" " "$url")

echo "$api_result" | awk '/^Location:/ { print $2 }'
