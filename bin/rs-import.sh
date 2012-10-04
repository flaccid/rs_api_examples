#!/bin/sh -e

# Warning: This script scrapes information from the RightScale dashboard (portal).  Do not use this script for production or any important purposes.  RightScale cannot guarantee this script to work now or in the future.

# rs-import.sh <library_id> 

[ ! "$1" ] && echo 'No library ID provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

library_id="$1"

url="https://my.rightscale.com/acct/$rs_api_account_id/library_helper/import/$library_id"
echo "GET: $url"

api_result=$(curl -s -H -S -I "X_API_VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

echo "$api_result" | awk '/^Location:/ { print $2 }'
