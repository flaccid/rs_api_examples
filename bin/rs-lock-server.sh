#!/bin/sh -e

# rs-unlock-server.sh <server_id>

[[ ! $1 ]] && echo 'No server ID provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

server_id="$1"

# Lock a running server
url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$server_id"
echo "PUT: $url"
api_result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" --request PUT \
-d "server[lock]=true" "$url")
echo "$api_result"