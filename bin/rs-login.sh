#!/bin/sh -e

# rs-login.sh

[ -e "$HOME"/rightscale ] || ( mkdir -p "$HOME"/rightscale && chmod -R 700 "$HOME"/.rightscale )

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

# get and store the cookie
url="https://my.rightscale.com/api/acct/$rs_api_account_id/login?api_version=$rs_api_version"
echo "GET: $url"
curl -s -c "$rs_api_cookie" -u "$rs_api_user":"$rs_api_password" "$url"