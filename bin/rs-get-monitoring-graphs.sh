#!/bin/sh -e

# rs-get-monitoring-graphs.sh <server_id>

# example: rs-get-monitoring-graphs.sh 1234

[ ! $1 ] && ( echo 'No server ID provided, exiting.'; exit 1 )

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_api_version="1.0"		# ensure API 1.0
server_id="$1"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$server_id/monitoring"
echo "GET: $url"

xml=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

echo "$xml"