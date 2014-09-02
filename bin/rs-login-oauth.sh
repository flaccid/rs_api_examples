#! /bin/sh -e

# rs-login-oauth.sh

# Ensure you have set rs_refresh_token in ~/.rightscale

# References
# http://support.rightscale.com/12-Guides/RightScale_API_1.5/Examples/Z_End-to-End_Examples/SAML_Provisioning_API_E2E#Create_a_RightScale_User_with_SAML

[ -e "$HOME"/.rightscale ] || ( mkdir -p "$HOME"/.rightscale && chmod -R 700 "$HOME"/.rightscale )

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

url="https://$rs_server/api/oauth2"
echo "[API 1.5] POST: $url"
result=$(curl -i -s -S -v -H 'X_API_VERSION: 1.5' -X POST \
	-d refresh_token="$rs_refresh_token" \
	-d grant_type='refresh_token' "$url" 2>&1)

case $result in
	*'200 OK'*)
		echo 'Login successful.'
		echo "$result" | tail -n 1
		exit
	;;
	*)
		echo 'Login failed!'
		echo "$result"
		exit 1
	;;
esac
