#!/bin/sh -e

# rs-reboot-server

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ ! $1 ]] && echo 'No server ID provided, exiting.' && exit 1
server_id="$1"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$server_id/reboot"
echo "GET: $url"
result=$(curl -s -d api_version="$rs_api_version" -b "$rs_api_cookie" "$url")

if [[ $result = *denied* ]]; then
	echo "$result" 
	exit 1
fi

echo "$result"