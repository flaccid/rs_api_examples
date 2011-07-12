#!/bin/bash -e

# rs-run-rightscript-tagged.sh right_script_id tag [additional_postdata]
#
# e.g.	rs-run-rightscript.sh 220337 "node:hostname=foo.bar.suf"
#		rs-run-rightscript.sh 400347 "node:hostname" "-d 'server[parameters][DOWNLOAD_DIR]=text:/tmp'"
#   

[[ ! $1 ]] && echo 'No right_script ID provided, exiting.' && exit 1
[[ ! $2 ]] && echo 'No tag ID provided, exiting.' && exit 1

script_id="$1"
TAG_SEARCH="$2"
[[ $3 ]] && add_post_data=" $3"

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

echo "Searching for servers with tag, '$TAG_SEARCH'"
url="https://my.rightscale.com/api/acct/$rs_api_account_id/tags/search?resource_type=ec2_instance&tags=$TAG_SEARCH"
echo "GET: $url"
api_result=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")
#echo "$api_result"

hrefs_xml=$(echo "$api_result" | grep "<href>" | uniq)    # get unique hrefs of servers with tag
#echo "hrefs_xml: $hrefs_xml"

# get the server IDs only
server_ids=$(while read -r line; do
	line=${line#*servers/}
	server_id=${line%%/*}
	echo "$server_id"
done <<< "$hrefs_xml")
#echo "$server_ids"

while read server_id; do
	echo
	echo "Running RightScript $script_id on $server_id."
	url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$server_id/run_script"
	post_data="-d right_script=https://my.rightscale.com/api/acct/$rs_api_account_id/right_scripts/$script_id$add_post_data"
	echo "POST: $url"
	echo "    post-data: $post_data"
	api_cmd="curl -s -b $rs_api_cookie -H X-API-VERSION:$rs_api_version $post_data $url"
	#echo "+ $api_cmd"
	$api_cmd
done <<< "$server_ids"


