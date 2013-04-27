#!/bin/sh -e

# rs-launch-server.sh <server_id>

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[ ! "$1" ] && echo 'No server ID provided, exiting.' && exit 1

server_id="$1"

url="https://$rs_server/api/acct/$rs_api_account_id/servers/$server_id/start"

echo "POST: $url"
api_result=$(curl -s -S -X POST -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

echo "$api_result"