#!/bin/bash -e

# rs-get-rightscripts

# e.g. rs-get-rightscripts

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_api_version=1.0

api_url="https://my.rightscale.com/api/acct/$rs_api_account_id/right_scripts"
echo "[API $rs_api_version] GET: $api_url"
api_result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$api_url")

echo "$api_result"