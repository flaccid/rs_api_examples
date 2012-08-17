#!/bin/sh -e

USAGE="Usage: `basename $0` <server_id> <sec_group_id>"

[ ! "$1" ] && echo 'No server ID provided, exiting.' && exit 1
[ ! "$2" ] && echo 'No security group ID provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

server_id="$1"
sec_group_id="$2"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$server_id"
# Exmaple: /api/acct/17/servers/650164
ARGS="server[ec2_security_groups_href]=https://my.rightscale.com/api/acct/$rs_api_account_id/ec2_security_groups/$sec_group_id"
# Example: /api/acct/44314/ec2_security_groups/45989001

echo "PUT: $url"
api_result=$(curl -i -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" --request PUT -d "$ARGS" "$url")
echo "$api_result"

