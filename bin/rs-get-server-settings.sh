#!/bin/sh -e

# rs-get-server-settings <server_id>

[[ ! $1 ]] && echo 'No server ID provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$1/settings"
echo "GET: $url"
api_result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")
echo "$api_result"