#!/bin/sh -e

# Warning: This sends a request to the RightScale dashboard.
# It is intended for internal purposes only.

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_observe_cookie="$HOME/.rightscale/rs_observe_cookie.txt"

curl -s -c "$rs_observe_cookie" -u "$rs_api_user":"$rs_api_password" \
  "https://my.rightscale.com/api/acct/72/login?api_version=1.0"

for account in "$@"
do
  echo "Attempting to observe account, $account..."
  curl -b "$rs_api_cookie" \
    -X POST \
    -H "Referer:https://my.rightscale.com/global/admin_accounts/$account" \
    -H "Host:my.rightscale.com" \
  "https://my.rightscale.com/global/admin_accounts/$account/access"
done
