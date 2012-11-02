#!/bin/sh -e

# rs-get-ebs-volumes.sh [<rs_cloud_id>]
# e.g. rs-get-ebs-volumes.sh
#      rs-get-ebs-volumes.sh 3
#      rs-get-ebs-volumes.sh all
#
# Note: specifying no rs_cloud_id currently only retrieves for cloud_id=1 (even without specifying cloud_id, server-side fetches for cloud_id=1 only at this time)

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_cloud_id="$1"
: ${rs_cloud_id:=1}

if [ "$rs_cloud_id" = 'all' ]; then
  for i in {1..7}
  do
    url="https://my.rightscale.com/api/acct/$rs_api_account_id/ec2_ebs_volumes?cloud_id=$i"
    echo "GET: $url"
    ebs_volumes+="$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")"
  done
  
  echo "$ebs_volumes"
else
  url="https://my.rightscale.com/api/acct/$rs_api_account_id/ec2_ebs_volumes?cloud_id=$rs_cloud_id"
  echo "GET: $url"

  result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

  echo "$result"
fi