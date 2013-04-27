#!/bin/bash -e

# rs-get-servers [<rs_cloud_id>] [<filter>]

# e.g. rs-get-servers.sh
#      rs-get-servers.sh 3
#      rs-get-servers.sh "nickname%3DUber+Servers%3A+Blitzkrieg"

# Notes: rs_cloud_id is required when using filter
#        filter is for API 1.0 only

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[ "$1" ] && cloud_id="cloud_id=$1"
[ "$2" ] && filter="&filter%5B%5D=$1"

case $rs_api_version in
	*1.0*)
    api_url="https://$rs_server/api/acct/$rs_api_account_id/servers?$cloud_id$filter"
    echo "[API $rs_api_version] GET: $api_url"
    api_result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$api_url")
	;;
  *1.5*)
    api_url="https://$rs_server/api/servers.xml"
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