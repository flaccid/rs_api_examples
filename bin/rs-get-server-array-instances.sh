#!/bin/sh -e

# rs-get-server-array-instances.sh <server_array_id>

[[ ! $1 ]] && echo 'No server array ID provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

array_id="$1"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/server_arrays/$array_id/instances"
echo "GET: $url"
api_result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")
echo "$api_result"