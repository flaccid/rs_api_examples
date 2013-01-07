#!/bin/bash -e

# rs-get-instances <rs_cloud_id>
# e.g.    rs-get-instances 232

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ ! $1 ]] && echo 'No rs_cloud_id ID provided, exiting.' && exit 1

rs_cloud_id="$1"
rs_api_version=1.5

api_url="https://my.rightscale.com/api/clouds/$rs_cloud_id/instances.xml"
echo "[API $rs_api_version] GET: $api_url"

api_result=$(curl -s -S -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$api_url")

echo "$api_result"