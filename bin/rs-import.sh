#!/bin/sh -e

# rs-import.sh <publication_id>

# To find the publication ID, open the publication in the dashboard from it's link in the marketplace, example:
# opening http://www.rightscale.com/library/server_templates/Load-Balancer-with-HAProxy-1-5/lineage/45420
# provides https://my.rightscale.com/library/server_templates/Load-Balancer-with-HAProxy-1-5/179414
# => 179414 is the publication ID

[ ! "$1" ] && echo 'No publication ID provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

# importing publications only supported in RS API 1.5
rs_api_version='1.5'

publication_id="$1"

url="https://$rs_server/api/publications/$publication_id/import"; 
echo "[API $rs_api_version] POST: $url"

api_result=$(curl -S -s -v -X POST -H "X_API_VERSION: $rs_api_version" -b "$rs_api_cookie" -d account_href=/api/accounts/$rs_api_account_id "$url" 2>&1)

case "$api_result" in 
  *Status:\ 201*)
    echo "$api_result" | awk '/^< Location:/ { print $3 }'
  ;;
  *)
    echo "FAILED: $api_result"
  ;;
esac
