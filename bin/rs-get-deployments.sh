#!/bin/sh -ex

# rs-geet-deployments.sh [filter] [settings] 
# e.g. rs-get-deployments.sh 'nickname[]=Red Dwarf'

[ "$1" ] && filter="?filter=$1"
[ "$2" = 'settings' ] && settings="&server_settings=true"

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/deployments$filter$settings"
echo "GET: $url"
api_result=$(curl -s -H "X_API_VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

echo "$api_result"