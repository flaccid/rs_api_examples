#!/bin/bash -e

# rs-run-rightscript-array.sh <rightscript_id> <server_array_id> [<servertemplate_id>]

# e.g.   rs-run-rightscript-array.sh 1234 4321

[[ ! $1 ]] && echo 'No rightscript ID provided, exiting.' && exit 1
[[ ! $2 ]] && echo 'No server array ID provided, exiting.' && exit 1
[[ ! $3 ]] && echo 'No servertemplate ID provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rightscript_id="$1"
server_array_id="$2"
server_template_id="$3"
api_url="https://my.rightscale.com/api/acct/$rs_api_account_id/server_arrays/$server_array_id/run_script_on_all"

echo "Running RightScript [$rightscript_id] on Server Array [$server_array_id]."
echo "GET: $api_url"
curl -H X-API-VERSION:"$rs_api_version" -X POST -b "$rs_api_cookie"\
-d "server_array[right_script_href]=https://my.rightscale.com/api/acct/$rs_api_account_id/right_scripts/$rightscript_id" \
-d "server_array[server_template_hrefs]=https://my.rightscale.com/api/acct/$rs_api_account_id/ec2_server_templates/$server_template_id" \
"$api_url"