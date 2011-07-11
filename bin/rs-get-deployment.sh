#!/bin/sh -e

# rs-describe-deployment.sh <deployment_id> [settings]

[[ ! $1 ]] && echo 'No deployment ID provided.' && exit 1

if [ "$2" = 'settings' ]; then
    settings="/?server_settings=true"
fi

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/deployments/$1$settings"
echo "GET: $url"
api_result=$(curl -s -H "X_API_VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

echo "$api_result"