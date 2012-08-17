#!/bin/sh -e

# rs-update-subnet.sh <server_id> <subnet_id>

[ ! "$1" ] && echo 'No server ID provided, exiting.' && exit 1
[ ! "$2" ] && echo 'No subnet ID provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

server_id="$1"
subnet_id="$2"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$server_id"
# Exmaple: /api/acct/17/servers/650164
ARGS="server[vpc_subnet_href]=https://my.rightscale.com/api/acct/$rs_api_account_id/vpc_subnets/$subnet_id"
# Exmaple: /api/acct/44134/vpc_subnets/201463001

echo "PUT: $url"
api_result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" --request PUT -d "$ARGS" "$url")
echo "$api_result"

# Exmaple call:
# https://my.rightscale.com/acct/44134/clouds/1/vpc_subnets/201430601
# curl PUT -d server[vpc_subnet_href]=https://my.rightscale.com/api/acct/17/vpc_subnets/625 https://my.rightscale.com/api/acct/17/servers/650164
# curl -i -u user@rightscale.com:<your password> -d api_version=1.0 -X

