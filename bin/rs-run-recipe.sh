#!/bin/bash -e

# rs-run-recipe.sh <server_or_instance_id> <recipe_name> [[extra curl post params]]

# e.g.  rs-run-recipe.sh 516031001 "rightscale::default" "server[ignore_lock]=true"
#
#       For API 1.5:
#       rs_api_version=1.5 rs_cloud_id=1869 rs-run-recipe.sh 1SR4O53A7PLFA "rightscale::setup_timezone" "inputs[][name]=rightscale/timezone" "inputs[][value]=text:Australia/Sydney"

[[ ! $1 ]] && echo 'No server_id ID provided, exiting.' && exit 1
[[ ! $2 ]] && echo 'No recipe name provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

server_id="$1"
recipe="$2"
shift; shift
for arg in "$@"; do
	args+=(-d "$arg")
done

# needs all common public cloud IDs inserted or substitute with API call if possible
case "$rs_cloud_id" in 
  1)
    rs_cloud="AWS US-East"
  ;;
  1869)
    rs_cloud="Softlayer"
  ;;
  *)
    rs_cloud="$rs_cloud_id"
  ;;
esac

case $rs_api_version in
	*1.0*)
    api_url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$server_id/current/run_executable"
    echo "Running Chef recipe [$recipe] on Server [$server_id]."
    echo "[API $rs_api_version] POST: $api_url"
    api_result=$(curl -s -S -i -X POST -b "$rs_api_cookie" -H X-API-VERSION:"$rs_api_version" -d server[recipe]="$recipe" "${args[@]}" "$api_url")
    case "$api_result" in 
      *Status:\ 201*)
        echo "$api_result" | awk '/^Location:/ { print $2 }'
      ;;
      *)
        echo "FAILED: $api_result"
      ;;
    esac
	;;
  *1.5*)
    instance_id="$server_id"
    api_url="https://my.rightscale.com/api/clouds/$rs_cloud_id/instances/$instance_id/run_executable"
    echo "Running Chef recipe [$recipe] on Instance [$server_id] in cloud [$rs_cloud]."
    echo "[API $rs_api_version] POST: $api_url"
    api_result=$(curl -s -S -i -X POST -b "$rs_api_cookie" -H X-API-VERSION:"$rs_api_version" -d recipe_name="$recipe" "${args[@]}" "$api_url")
    case "$api_result" in 
      *Status:\ 202\ Accepted*)
        echo "$api_result" | awk '/^Location:/ { print $2 }'
      ;;
      *)
        echo "FAILED: $api_result"
      ;;
    esac
	;;
esac