#!/bin/sh -e

# rs-get-sketchy-data.sh <server_id> <plugin_name> <plugin_type> <start> <end>
# example: rs-get-sketchy-data.sh 1234 cpu-0 cpu-idle -3600 0

( [ ! $1 ] || [ ! $2 ] || [ ! $3 ] || [ ! $4 ] || [ ! $5 ] ) && echo 'Insufficent options.\n Usage: rs-get-sketchy-data.sh <server_id> <plugin_name> <plugin_type> <start> <end>' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_api_version="1.0"		# ensure API 1.0

server_id="$1"
plugin_name="$2"
plugin_type="$3"
start="$4"
end="$5"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$server_id/current/get_sketchy_data"
echo "GET: $url"

xml=$(curl -s -d api_version="$rs_api_version" -H "X-API-VERSION: $rs_api_version" --request GET -b "$rs_api_cookie" -d "start=$start" -d "end=$end" -d "plugin_name=$plugin_name" -d "plugin_type=$plugin_type" "$url")

echo "$xml"