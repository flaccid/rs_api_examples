#!/bin/bash -e

# rs-disable-array.sh <server_array_id>

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ ! $1 ]] && echo 'No server array ID provided, exiting.' && exit 1

array_id="$1"

url="https://my.rightscale.com/api/acct/"$rs_api_account_id"/server_arrays/"$array_id""
echo "[API $rs_api_version] PUT: $url"

api_result=$(curl -X PUT -S -s -v -d api_version="$rs_api_version" -b "$rs_api_cookie" -d "server_array[active]=false" "$url" 2>&1)

case "$api_result" in 
  *204\ No\ Content*)
    echo "Server array, $array_id successfully disabled."
  ;;
  *)
    echo "FAILED: $api_result"
  ;;
esac