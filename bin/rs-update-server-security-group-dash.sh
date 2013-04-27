#!/bin/sh -e

# rs-update-server-security-group-dash.sh <server_id> <ec2_security_group_id> <deployment_id> <server_template_id> <ebs_optimized> [[debug]]

# e.g. rs-update-server-security-group-dash.sh 256660008 285049008 214931008 213739008 231678008 0 debug

[ ! "$1" ] && echo 'No server ID provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_server_id="$1"
ec2_security_group_id="$2"
deployment_id="$3"
server_template_id="$4"
ec2_ssh_key_id="$5"
ebs_optimized="$6"

authenticity_token=$(./rs-get-authenticity-token-dash.sh $1)

if [ "$7" == 'debug' ]; then
	echo "Authenticity token: $authenticity_token"
fi

url="https://$rs_server/acct/$rs_api_account_id/servers/$rs_server_id/info?next_server=true"
echo "POST: $url"

result=$(curl -v -S -s -X POST \
-b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
-H "Content-Type:application/x-www-form-urlencoded; charset=UTF-8" \
-H "Host:$rs_server" \
-H "Origin:https://$rs_server" \
-H "Referer:https://$rs_server/acct/$rs_api_account_id/servers/$rs_server_id/info;edit" \
-H "X-Requested-With:XMLHttpRequest" \
-d next_server="true" \
-d runnable[deployment_id]="$deployment_id" \
-d id="$rs_server_id" \
-d stage_names[]='ServerTemplate' \
-d stage_names[]='Server Details' \
-d stage_names[]='Confirm' \
-d _method='put' \
-d authenticity_token="$authenticity_token" \
-d runnable[ec2_security_group_ids][]="$ec2_security_group_id" \
-d runnable[server_template_id]="$server_template_id" \
-d runnable[ec2_ssh_key_id]="$ec2_ssh_key_id" \
-d runnable[ebs_optimized]="$ebs_optimized" \
"$url" 2>&1)

case $result in
	*'redirect_url'*)
		echo 'Server successfully updated.'
		echo "$result" | grep redirect_url
		exit
	;;
	*)
		echo 'Server update failed!'
		echo "$result"
		exit 1
	;;
esac