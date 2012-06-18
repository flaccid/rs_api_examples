#!/bin/sh -e

# rs-delete-ebs-snapshot.sh <ec2_ebs_snapshot_id>

[[ ! $1 ]] && echo 'No EC2 EBS snapshot ID provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

vol_id="$1"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/ec2_ebs_snapshots/$vol_id"
echo "DELETE: $url"

api_result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" --request DELETE "$url")

echo "$api_result"