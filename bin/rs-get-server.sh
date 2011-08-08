#!/bin/sh -e

# rs-get-server.sh <server_id> [current]

[[ ! $1 ]] && echo 'No server ID provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

if [ "$2" ]; then
    current="/$2"
fi

url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$1$current"
echo "GET: $url"
server_xml=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")
echo "$server_xml"