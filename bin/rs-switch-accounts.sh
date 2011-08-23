#!/bin/sh -e

# rs-switch-accounts.sh <account_id>

[ ! "$1" ] && echo 'No account ID provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_api_account_id="$1"

cat <<EOF> "$HOME/.rightscale/rs_api_creds.sh"
rs_api_account_id=$rs_api_account_id
rs_api_user="$rs_api_user"
rs_api_password="$rs_api_password"
EOF

rs-login.sh