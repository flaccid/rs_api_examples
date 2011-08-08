#!/bin/sh -e

# rs-assoc-eip-next.sh <server_id> <eip_id>

[[ ! $1 ]] && echo 'No server ID provided.' && exit 1
[[ ! $2 ]] && echo 'No elastic IP ID provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

server_id="$1"
eip_id="$2"

# Associate EIP on launch to a next server
url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$server_id?resource_href=https://my.rightscale.com/api/acct/7954/ec2_instances/7800892"
echo "PUT: $url"
api_result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" --request PUT \
-d "server[ec2_elastic_ip_href]=https://my.rightscale.com/api/acct/$rs_api_account_id/ec2_elastic_ips/$eip_id" \
-d "server[associate_eip_at_launch]=1" \
"$url")

echo "$api_result"