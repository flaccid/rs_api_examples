#!/bin/sh -e

# rs-get-server-arrays

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

url="https://$rs_server/api/acct/$rs_api_account_id/server_arrays"
echo "GET: $url"

api_result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

echo "$api_result"
