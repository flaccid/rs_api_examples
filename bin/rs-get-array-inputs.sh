#! /bin/sh -e

# rs-get-array-inputs <server_array_id>

# e.g. rs-get-array instances 224896003
#      rs_api_version=1.0 rs-get-array-instances 224896003

[ ! "$1" ] &&	echo 'No server array ID provided, exiting.'

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

array_id="$1"

echo "Fetching current inputs for server array, $array_id."

if [ "$rs_api_version" = 1.5 ]; then
	# need to follow via http://reference.rightscale.com/api1.5/resources/ResourceServerArrays.html#show
else
	# not possible?
  # http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiEc2ServerArrays.html
  exit 1
fi

echo 'This example is unfinished.'
exit 1

echo "[API $rs_api_version] GET: $url"

api_result=$(curl -X GET -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

echo "$api_result"
