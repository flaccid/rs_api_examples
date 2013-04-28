#!/bin/sh -e

# rs-detach-ebs-volume.sh <volume_id>

[[ ! $1 ]] && echo 'No EC2 EBS volume ID provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

vol_id="$1"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/component_ec2_ebs_volumes/$vol_id"
echo "DELETE: $url"

api_result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" --request DELETE "$url")

echo "$api_result"