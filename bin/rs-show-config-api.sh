# !/bin/bash -e

# rs-show-config-api.sh

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

#cat "$HOME/.rightscale/rs_api_config.sh"
#cat "$HOME/.rightscale/rs_api_creds.sh"

echo '== RightScale API profile =='
echo "User: $rs_api_user"
echo "Password: <hidden>"
echo "Account ID: $rs_api_account_id"
echo "Server/shard: $rs_server"
echo "API Version: $rs_api_version"
echo "=="
echo