#!/bin/sh -e

# rs-create-deployment.sh <deployment_nickname> <deployment_description>

[ ! "$1" ] && echo 'No deployment nickname provided.' && exit 1
[ ! "$2" ] && echo 'No deployment description provided.' && exit 1

nickname="$1"
description="$2"

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/deployments"
echo "POST: $url"

api_result=$(curl -s -H "X_API_VERSION: $rs_api_version" -X POST -b "$rs_api_cookie" \
	-d "deployment[nickname]=$nickname" \
	-d "deployment[description]=$description" \
	"$url")

echo "$api_result"

