#!/bin/sh -e

# rs-clone-deployment.sh <deployment_id> 

[ ! "$1" ] && echo 'No deployment ID provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/deployments/$1/duplicate"
# /api/acct/1/deployments/1/duplicate
echo "POST: $url"
api_result=$(curl -s -H "X_API_VERSION: $rs_api_version" -X POST -b "$rs_api_cookie" "$url")

echo "$api_result"

