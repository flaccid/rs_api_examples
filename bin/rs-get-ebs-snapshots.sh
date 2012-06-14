#!/bin/sh -e

# rs-get-ebs-snapshots.sh [<query_string>]

# note: api 1.0 currently does not support any server-side filtering

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_api_version=1.0

url="https://my.rightscale.com/api/acct/$rs_api_account_id/ec2_ebs_snapshots$1"
echo "GET: $url"

xml=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

echo "$xml"