#!/bin/sh -e

# rs-get-taggable-resources.sh

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/tags/taggable_resources"
echo "GET: $url"
api_result=$(curl -s -H "X-API-VERSION:$rs_api_version" -b "$rs_api_cookie" "$url")

echo "$api_result"