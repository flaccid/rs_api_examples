#!/bin/bash -e

# rs-grant-observe-saml.sh

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ ! $rs_access_token ]] && echo 'No access_token provided, exiting.' && exit 1
[[ ! $1 ]] && echo 'No user href provided, exiting.' && exit 1

rs_api_version=1.5
user_href="$1"

api_url="https://$rs_server/api/permissions"
echo "[API $rs_api_version] POST: $api_url"

api_result=$(curl -v -s -S \
	-X POST \
	-H "X-API-VERSION: $rs_api_version" \
	-H "Authorization: Bearer $rs_access_token" \
	-d permission[user_href]="$user_href" \
 	-d permission[role_title]=observer \
	"$api_url" 2>&1)

case $api_result in
	*'201 Created'*)
		echo 'Permission granted.'
		echo "$api_result" | grep Location
		exit
	;;
	*)
		echo 'Permission set failed!'
		echo "$api_result"
		exit 1
	;;
esac
