#!/bin/sh -e

# rs-get-access-token.sh

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

token_endpoint="https://$rs_server/api/oauth2"

api_result=$(curl -Ssv \
  -H 'X-API-Version: 1.5' \
  --request POST "$token_endpoint" \
  -d 'grant_type=refresh_token' \
  -d "refresh_token=$rs_api_refresh_token")

echo "$api_result" > "$HOME/.rightscale/oauth.json"
# chmod 400 "$HOME/.rightscale/oauth.json"

rs_api_access_token=$(echo "$api_result" | jq -r .access_token)
grep -v "rs_api_access_token" "$HOME/.rightscale/rs_api_creds.sh" > temp && mv temp "$HOME/.rightscale/rs_api_creds.sh"
echo "rs_api_access_token=$rs_api_access_token" >> "$HOME/.rightscale/rs_api_creds.sh"
