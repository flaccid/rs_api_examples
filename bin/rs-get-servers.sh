#!/bin/bash -e

# rs-get-servers [<filter]

# e.g. rs-get-servers.sh
#      rs-get-servers.sh "nickname%3DUber+Servers%3A+Blitzkrieg"

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[ "$1" ] && filter="?filter%5B%5D=$1"

case $rs_api_version in
	*1.0*)
    api_url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers$filter"
    echo "[API $rs_api_version] GET: $api_url"
    api_result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$api_url")
	;;
  *1.5*)
    api_url="https://my.rightscale.com/api/servers.xml"
    echo "[API $rs_api_version] GET: $api_url"
    api_result=$(curl -s -S -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$api_url")
  ;;
esac

case "$api_result" in 
  \<*\>)
    echo "$api_result"
  ;;
  *)
    echo "FAILED: $api_result"
  ;;
esac