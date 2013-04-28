#!/bin/sh -e

# rs-update-server-vpc-subnet.sh <rs_server_id> <rs_ec2_vpc_subnet_id>

# e.g. rs-update-server-vpc-subnet.sh 256652022 285049011

# Note: this is mainly intended after creation of a server due to http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiComponents.html#create (see/use rs-create-server-vpc.sh)

usage="Usage: `basename $0` <server_id> <sec_group_id>"

[ ! "$1" ] && echo 'No server ID provided, exiting.' && exit 1
[ ! "$2" ] && echo 'No VPC subnet ID provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_server_id="$1"
vpc_subnet_id="$2"

url="https://$rs_server/api/acct/$rs_api_account_id/servers/$rs_server_id"
ARGS="server[vpc_subnet_href]=https://$rs_server/api/acct/$rs_api_account_id/vpc_subnet_href/$vpc_subnet_id"

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