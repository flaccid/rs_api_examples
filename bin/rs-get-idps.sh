#!/bin/bash -e

# rs-get-idps.sh

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ ! $1 ]] && [[ ! $rs_access_token ]] && echo 'No access_token provided, exiting.' && exit 1

rs_api_version=1.5
[[ ! $rs_access_token ]] && rs_access_token=$1
api_url="https://$rs_server/api/identity_providers.xml"

echo "[API $rs_api_version] GET: $api_url"

api_result=$(curl -v 	-s -S \
	-H "X-API-VERSION: $rs_api_version" \
	-H "Authorization: Bearer $rs_access_token" "$api_url" 2>&1)

case $api_result in
	*'200 OK'*)
		echo 'Login successful.'
		echo "$api_result"
		exit
	;;
	*)
		echo 'Login failed!'
		echo "$api_result"
		exit 1
	;;
esac
