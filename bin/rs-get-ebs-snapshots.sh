#!/bin/sh -e

# rs-get-ebs-snapshots.sh [<query_string>]

 #To match nicknames with splunk23 in them:
 #?cloud_id=1&filter=nickname~splunk23"

 #To match nicknames that match splunk23-34567 exactly:
 #?cloud_id=1&filter=nickname=splunk23-34567"

 #To match nicknames that don't match splunk23:
 #?cloud_id=1&filter=nickname<>splunk23"

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_api_version=1.0

url="https://my.rightscale.com/api/acct/$rs_api_account_id/ec2_ebs_snapshots$1"
echo "GET: $url"

xml=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

echo "$xml"