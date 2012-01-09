#! /bin/sh -e

# rs-login.sh

# References
# http://support.rightscale.com/12-Guides/RightScale_API_1.5/Authentication

[ -e "$HOME"/rightscale ] || ( mkdir -p "$HOME"/rightscale && chmod -R 700 "$HOME"/.rightscale )

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

# get and store the cookie
if [ "$rs_api_version" == 1.5 ]; then
	curl -H 'X_API_VERSION: 1.5' -c "$rs_api_cookie" -X POST -d email="$rs_api_user" -d password="$rs_api_password" -d account_href=/api/accounts/$rs_api_account_id https://my.rightscale.com/api/session
else
	url="https://my.rightscale.com/api/acct/$rs_api_account_id/login?api_version=$rs_api_version"
	echo "GET: $url"
	curl -s -c "$rs_api_cookie" -u "$rs_api_user":"$rs_api_password" "$url"
fi