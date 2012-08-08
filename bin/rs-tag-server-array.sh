#!/bin/bash -e

# rs-tag-server-array.sh <server_array_id> <tag_foo>

# e.g.   rs-tag-server-array.sh 123456 "reddwarf:rocks=true"

[[ ! $1 ]] && echo 'No server_array_id ID provided, exiting.' && exit 1
[[ ! $2 ]] && echo 'No tag provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

server_array_id="$1"
tags="$2"

echo "Fetching Server Array, $server_array_id."
url="https://my.rightscale.com/api/acct/$rs_api_account_id/server_arrays/$server_array_id"
echo "GET: $url"
api_result=$(curl -i -S -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url")

server_array_href=$(echo $api_result | sed -e 's/.*<href>\(.*\)<\/href>.*/\1/p' | head -n 1)        # this is bad but means no extra library is required, see http://www.codinghorror.com/blog/2009/11/parsing-html-the-cthulhu-way.html

echo "Setting tag, '$2' on server array, $server_array_href."

api_url="https://my.rightscale.com/api/acct/$rs_api_account_id/tags/set"
echo "GET: $api_url"
api_result=$(curl -S -s -i -X PUT -b "$rs_api_cookie" -H X-API-VERSION:"$rs_api_version" -d resource_href="$server_array_href" -d tags[]="$tags" "$api_url")

case "$api_result" in 
  *Status:\ 204*)
    echo "$api_result" | awk '/^Location:/ { print $2 }'
  ;;
  *)
    echo "FAILED: $api_result"
  ;;
esac