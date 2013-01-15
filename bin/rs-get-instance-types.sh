#!/bin/bash -e

# rs-get-instance-types.sh <rs_cloud_id>

# e.g. rs-get-instance-types.sh 232                         # 232=Rackspace
#      rs_api_version=1.5 rs-get-instance-types.sh 1869     # 1869=Softlayer

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ ! $1 ]] && echo 'No RightScale cloud ID provided.' && exit 1

: ${rs_api_version="1.5"}
rs_cloud_id="$1"

case $rs_api_version in
	*1.0*)
		echo 'This operation is not supported in RightScale API 1.0, exiting.'
		exit 1
	;;
	*1.5*)
		api_url="https://my.rightscale.com/api/clouds/$rs_cloud_id/instance_types.xml"
		echo "[API $rs_api_version] GET: $api_url"
		api_result=$(curl -s -S -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$api_url")
	;;
esac

echo "$api_result"