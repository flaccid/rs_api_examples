#! /bin/bash -e

# rs-start-server.sh <server_id>

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ ! $1 ]] && echo 'No server ID provided, exiting.' && exit 1

server_id="$1"
rs_api_version='1.0'
url="https://$rs_server/api/acct/$rs_api_account_id/servers/$server_id/start_ebs"

echo "[API $rs_api_version] POST: $url"

api_result=$(curl -s -S -v -X POST -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" $url 2>&1)

case $api_result in
    *"201 Created"*)
      echo 'Server start request successfully sent.'
    ;;
    *)
      echo 'Server start request failed!'
      echo "$api_result"
      exit 1
    ;;
esac
