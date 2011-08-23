#!/bin/bash -e

# rs-terminate-server.sh <server_id>

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ ! $1 ]] && echo 'No server ID provided, exiting.' && exit 1
server_id="$1"

stop_server() {
	url="https://my.rightscale.com/api/acct/"$rs_api_account_id"/servers/"$server_id"/stop"
	echo "GET: $url"
    stop_result=$(curl -d api_version="$rs_api_version" -b "$rs_api_cookie" -sL -w "\\n%{http_code} %{url_effective}" "$url")
	stop_code=$(tail -n1 <<< $stop_result | awk '{print $1}')
	if [[ "$stop_result" = *denied* ]] || [ ! "$stop_code" = "201" ]; then
		echo "response: $stop_result"
		echo 'Failed to stop server.'
		exit 1
	fi
}

# terminate the server
stop_server