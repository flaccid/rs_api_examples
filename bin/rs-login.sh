#! /bin/sh -e

# rs-login.sh

# by default API 1.0 is used unless rs_api_version=1.5 is set in env or ~/.rightscale/rs_api_config.sh
# e.g. rs_api_config=1.5 rs-login.sh

# References
# http://support.rightscale.com/12-Guides/03-RightScale_API/RightScale_API_Examples/Authentication
# http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiLogins.html
# http://support.rightscale.com/12-Guides/RightScale_API_1.5/Authentication
# http://reference.rightscale.com/api1.5/index.html

[ -e "$HOME"/.rightscale ] || ( mkdir -p "$HOME"/.rightscale && chmod -R 700 "$HOME"/.rightscale )

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"


# get and store the cookie
if [ "$rs_api_version" = "1.5" ]; then
	url="https://$rs_server/api/session"
	echo "[API 1.5] POST: $url"
	result=$(curl -s -S -v -H 'X_API_VERSION: 1.5' -c "$rs_api_cookie" -X POST -d email="$rs_api_user" -d password="$rs_api_password" -d account_href=/api/accounts/$rs_api_account_id "$url" 2>&1)
else
	url="https://$rs_server/api/acct/$rs_api_account_id/login?api_version=$rs_api_version"
	echo "[API 1.0] GET: $url"
	result=$(curl -s -S -v -c "$rs_api_cookie" -u "$rs_api_user":"$rs_api_password" "$url" 2>&1)
fi

case $result in
	*'204 No Content'*)
		echo 'Login successful.'
		exit
	;;
	*)
		echo 'Login failed!'
		echo "$result"
		exit 1
	;;
esac
