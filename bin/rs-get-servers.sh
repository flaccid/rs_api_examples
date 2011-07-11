#!/bin/bash -e

# rs-get-servers

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers"
echo "GET: $url"
servers=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")
echo "$servers"