#!/bin/bash

# rs-ping-tagged-servers.sh

# RightScript: Ping all EC2 servers with a tag

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ $1 ]] && TAG_SEARCH="$1"
: ${TAG_SEARCH="rs_login%3Astate%3Dactive"}    # default: tags with rs_login:state=active

url="https://my.rightscale.com/api/acct/$rs_api_account_id/tags/search?resource_type=ec2_instance&tags=$TAG_SEARCH"
echo "GET: $url"
api_result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")
#echo "$api_result" | grep "<state>operational"

hrefs_xml=$(echo "$api_result" | grep "<href>" | uniq)    # get unique hrefs of servers with tag
#echo "hrefs_xml: $hrefs_xml"

# get the server IDs only
server_ids=$(while read -r line; do
	line=${line#*servers/}
	server_id=${line%%/*}
	echo "$server_id"
done <<< "$hrefs_xml")
#echo "$server_ids"

echo "Search and ping servers with tag, '"$TAG_SEARCH"'".
while read server_id; do
	tag_element="<ip-address>"
	echo "    INFO: get-server-settings($server_id)"
	server_settings_xml=$(rs-get-server-settings.sh "$server_id")
	read ip_xml <<< $(echo "$server_settings_xml" | grep "$tag_element")
	ip_xml="${ip_xml#*>}"
	ip="${ip_xml%<*}"
	read aws_id_xml <<< $(echo "$server_settings_xml" | grep "aws-id")
	aws_id_xml="${aws_id_xml#*>}"
	aws_id="${aws_id_xml%<*}"
	if [[ $ip ]]; then
		echo '        AWS Instance ID: '"$aws_id"
		echo '        RightScale Server ID: '"$server_id"
		echo '        IP Address: '"$ip"
		#echo "$server_settings_xml"
		ping -c 3 "$ip"
	else
		echo "    INFO: $server_id has no IP address."
	fi
done <<< "$server_ids"

echo 'Ping test complete.'