#! /bin/bash -e

# rs-stop-server.sh <server_id>

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ ! $1 ]] && echo 'No server ID provided, exiting.' && exit 1
server_id="$1"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$server_id/current/stop_ebs"

echo "GET: $url"

api_result=$(curl -s -S -v -X POST -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" $url 2>&1)

case $api_result in
    *"201 Created"*)
      echo 'Server stop request successfully sent.'
    ;;
    *)
      echo 'Server stop request failed!'
      echo "$api_result"
      exit 1
    ;;
esac