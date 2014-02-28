#!/bin/sh -e

# rs-get-re-attachments.sh

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[ ! "$1" ] && echo 'No cloud ID provided.' && exit 1

# lets support api 1.5 only first
rs_api_version='1.5'
cloud_id="$1"

url="https://$rs_server/api/clouds/$cloud_id/recurring_volume_attachments"
echo "[API $rs_api_version] GET: $url"

api_result=$(curl -S -s -H "X_API_VERSION: $rs_api_version" -b "$rs_api_cookie" "$url" 2>&1)

if [ "$?" = '0' ]; then
  echo "$api_result"
else
  echo "FAILED: $api_result"
fi
