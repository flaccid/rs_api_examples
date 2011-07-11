#!/bin/sh -e

# rs-launch-server.sh <server_id>

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ ! $1 ]] && echo 'No server ID provided, exiting.' && exit 1
server_id="$1"

# launch the server
start_server() {
	url="https://my.rightscale.com/api/acct/"$rs_api_account_id"/servers/"$server_id"/start"
	echo "GET: $url"
    start_result=$(curl -d api_version="$rs_api_version" -b "$rs_api_cookie" -sL -w "\\n%{http_code} %{url_effective}" "$url")
    echo "$start_result"
}

start_server