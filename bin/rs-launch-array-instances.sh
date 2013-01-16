#!/bin/sh -e

# rs-launch-array-instances.sh <server_array_id> <number_of_instances_to_launch>

# if no <number_of_instances_to_launch> is specified, 1 instance is launched

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ ! $1 ]] && echo 'No server array ID provided, exiting.' && exit 1
[[ ! $2 ]] && echo 'No instances count provided, exiting.' && exit 1

array_id="$1"
instances_count=$2

url="https://my.rightscale.com/api/acct/"$rs_api_account_id"/server_arrays/"$array_id"/launch"

for ((i=0; i<instances_count; i++)); do
  echo "[API $rs_api_version] POST: $url ($i)"
  api_result=$(curl -X POST -S -s -d api_version="$rs_api_version" -b "$rs_api_cookie" "$url" 2>&1)
  echo "$api_result"
done