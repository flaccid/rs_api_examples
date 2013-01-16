#!/bin/bash -e

# rs-terminate-array.sh <server_array_id>

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ ! $1 ]] && echo 'No server array ID provided, exiting.' && exit 1

array_id="$1"

terminate_array() {
	url="https://my.rightscale.com/api/acct/"$rs_api_account_id"/server_arrays/"$array_id"/terminate_all"
	echo "[API $rs_api_version] GET: $url"
  api_result=$(curl -S -s -d api_version="$rs_api_version" -b "$rs_api_cookie" "$url")
  echo "$api_result"
}

# terminate all in the server array
terminate_array