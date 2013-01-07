#!/bin/bash -e

# rs-get-servers

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

case $rs_api_version in
	*1.0*)
    api_url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers"
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