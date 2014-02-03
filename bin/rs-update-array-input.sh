#!/bin/sh -e

# rs-update-input.sh <array-id> <input-name> <input-value>

# e.g. rs-update-input 836587 'WEATHER_STATE' 'text:rainy' current
#      rs-update-input 836587 'WEATHER_STATE' 'text:sunny'

# http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiEc2ServerArrays.html#update

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

if [ "$4" ]; then
  current="/$4"
fi

params="server_array[parameters][$2]=$3"
echo "params: $params"

url="https://$rs_server/api/acct/$rs_api_account_id/server_arrays/$1$
echo "PUT: $url"

curl -H "X-API-VERSION:$rs_api_version" -b "$rs_api_cookie" --request PUT -d "$params" "$url"
