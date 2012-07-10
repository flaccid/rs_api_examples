#! /bin/sh -ex

# rs-query-cloud.sh

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

cloud_id="$1"
#url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$cloud_id/ec2_instances/requery"
url="https://my.rightscale.com/acct/27231/dashboard;overview"
curl -b "$rs_api_cookie" "$url"

#curl -s -c "$rs_api_cookie" -u "$rs_api_user":"$rs_api_password" "$url"
