#!/bin/bash -e

# rs-get-ebs-volumes

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/ec2_ebs_volumes"
echo "GET: $url"

xml=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

echo "$xml"