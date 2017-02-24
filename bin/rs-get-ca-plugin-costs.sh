#!/bin/sh -e

# rs-get-ca-plugin-costs.sh

# e.g. rs-get-ca-plugin-costs.sh

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_ca_api_version=1.0

api_url='https://analytics.rightscale.com/api/plugin_costs'

echo "[API $rs_ca_api_version] GET: $api_url"

api_result=$(curl -Ss --include \
  -H "X-API-Version: $rs_ca_api_version" \
  -b "$rs_api_cookie"  \
  --request GET "$api_url")

case $api_result in
	*'200 OK'*)
		echo "$api_result"
		exit
	;;
	*)
		echo 'API query failed!'
		echo "$result"
		exit 1
	;;
esac
