#!/bin/sh -e

# rs-get-alert-specs.sh

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_api_version="1.0"		# ensure API 1.0

url="https://my.rightscale.com/api/acct/$rs_api_account_id/alert_specs"
echo "GET: $url"

xml=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

echo "$xml"