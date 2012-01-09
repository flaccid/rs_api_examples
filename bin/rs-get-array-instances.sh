#! /bin/sh -e

# rs-get-array-instances <server_array_id> [<api_version>]

if [ ! "$1" ]; then 
	echo 'No server array ID provided, exiting.'
	echo "Usage: rs-get-array-instances <server_array_id> [<api_version>]"
	exit 1
fi

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

array_id="$1"
[ "$2" ] && rs_api_version="$2"

if [ "$rs_api_version" = 1.5 ]; then
	url="https://my.rightscale.com/api/server_arrays/$array_id/current_instances.xml"
else
	url="https://my.rightscale.com/api/acct/$rs_api_account_id/server_arrays/$array_id"
fi

echo "GET: $url"
api_result=$(curl -X GET -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")
echo "$api_result"