#!/bin/sh -e

# rs-update-input.sh <server_id> <input-name> <input-value> [current]

# e.g. rs-update-input 836587 'WEATHER_STATE' 'text:rainy' current
#      rs-update-input 836587 'WEATHER_STATE' 'text:sunny'
       
. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

if [ "$4" ]; then
     current="/$4"
fi

params="server[parameters][$2]=$3"
echo "params: $params"
url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$1$current"
echo "PUT: $url"
curl -H "X-API-VERSION:$rs_api_version" -b "$rs_api_cookie" --request PUT -d "$params" "$url"