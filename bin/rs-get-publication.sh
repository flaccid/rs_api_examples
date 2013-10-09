#!/bin/sh -e

# rs-get-publication.sh <publication_id>

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[ ! "$1" ] && echo 'No publication ID provided.' && exit 1

# publications only supported in RS API 1.5
rs_api_version='1.5'

publication_id="$1"

url="https://$rs_server/api/publications/$publication_id"
echo "[API $rs_api_version] GET: $url"

api_result=$(curl -S -s -H "X_API_VERSION: $rs_api_version" -b "$rs_api_cookie" "$url" 2>&1)

if [ "$?" = '0' ]; then
  echo "$api_result"
else
  echo "FAILED: $api_result"
fi
