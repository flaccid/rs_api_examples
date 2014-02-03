#! /bin/sh -e

# rs-get-array-instances <server_array_id>

# e.g. rs-get-array instances 224896003
#      rs_api_version=1.0 rs-get-array-instances 224896003

[ ! "$1" ] &&	echo 'No server array ID provided, exiting.'

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

array_id="$1"

echo "Fetching current instances for server array, $array_id."

if [ "$rs_api_version" = 1.5 ]; then
	url="https://$rs_server/api/server_arrays/$array_id/current_instances.xml"
else
	url="https://$rs_server/api/acct/$rs_api_account_id/server_arrays/$array_id/instances"
fi

echo "[API $rs_api_version] GET: $url"

api_result=$(curl -X GET -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

echo "$api_result"
