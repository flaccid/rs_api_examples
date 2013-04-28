#!/bin/sh -e

# rs-update-server-security-group.sh <rs_server_id> <rs_ec2_security_group_id>

# e.g. rs-update-server-security-group.sh 256652008 285049008

# Note: this is mainly intended after creation of a server due to http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiComponents.html#create (see/use rs-create-server-vpc.sh)

usage="Usage: `basename $0` <server_id> <sec_group_id>"

[ ! "$1" ] && echo 'No server ID provided, exiting.' && exit 1
[ ! "$2" ] && echo 'No security group ID provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

server_id="$1"
sec_group_id="$2"

url="https://$rs_server/api/acct/$rs_api_account_id/servers/$server_id"
# Exmaple: /api/acct/17/servers/650164
ARGS="server[ec2_security_groups_href]=https://$rs_server/api/acct/$rs_api_account_id/ec2_security_groups/$sec_group_id"
# Example: /api/acct/44314/ec2_security_groups/45989001

echo "PUT: $url"

api_result=$(curl -v -s -S -i -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" --request PUT -d "$ARGS" "$url" 2>&1)

case $api_result in
	*'204 No Content'*)
		echo 'Server successfully updated.'
		exit
	;;
	*)
		echo 'Server update failed!'
		echo "$api_result"
		exit 1
	;;
esac