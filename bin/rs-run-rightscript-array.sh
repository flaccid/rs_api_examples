#! /bin/bash -e

# rs-run-rightscript-array.sh <rightscript_id> <server_array_id> [<servertemplate_id>]
#
# e.g.    rs-run-rightscript-array.sh 278706001 203474001 226619001
#
# source: https://github.com/flaccid/rs_api_examples/blob/master/bin/rs-run-rightscript-array.sh

[[ ! $1 ]] && echo 'No rightscript ID provided, exiting.' && exit 1
[[ ! $2 ]] && echo 'No server array ID provided, exiting.' && exit 1
[[ ! $3 ]] && [ "$rs_api_version" != "1.5" ] && echo 'No servertemplate ID provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rightscript_id="$1"
server_array_id="$2"
server_template_id="$3"

if [ "$rs_api_version" = "1.5" ]; then
  url="https://my.rightscale.com/api/server_arrays/$server_array_id/multi_run_executable"
  echo "Running RightScript [$rightscript_id] on Server Array [$server_array_id]."
  echo "[API $rs_api_version] POST: $url"
  api_result=$(curl -s -S -v -H X-API-VERSION:"$rs_api_version" -X POST -b "$rs_api_cookie" \
    -d "right_script_href=https://my.rightscale.com/api/right_scripts/$rightscript_id" \
    "$url" 2>&1)
else
  url="https://my.rightscale.com/api/acct/$rs_api_account_id/server_arrays/$server_array_id/run_script_on_all"
  echo "Running RightScript [$rightscript_id] on Server Array [$server_array_id] from ServerTemplate [$server_template_id]."
  echo "[API $rs_api_version] POST: $url"
  api_result=$(curl -s -S -H X-API-VERSION:"$rs_api_version" -X POST -b "$rs_api_cookie" \
    -d "server_array[right_script_href]=https://my.rightscale.com/api/acct/$rs_api_account_id/right_scripts/$rightscript_id" \
    -d "server_array[server_template_hrefs]=https://my.rightscale.com/api/acct/$rs_api_account_id/ec2_server_templates/$server_template_id" \
    "$url" 2>&1)
fi

case "$api_result" in 
  *audit-entries*)
    echo "RightScript run successfully processed."
    echo "$api_result"
    exit
  ;;
  *202\ Accepted*)
    echo "RightScript run successfully processed."
    exit  
  ;;
  *)
    echo "FAILED: $api_result"
    exit 1
  ;;
esac