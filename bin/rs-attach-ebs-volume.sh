#! /bin/bash -e

# rs-attach-ebs-volume.sh <server_id> <ec2_ebs_volume_href> <device>

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[[ ! $1 ]] && echo 'No server ID provided, exiting.' && exit 1
[[ ! $2 ]] && echo 'No EC2 EBS volume HRef provided, exiting.' && exit 1
[[ ! $3 ]] && echo 'No device name provided, exiting.' && exit 1

server_id="$1"
ec2_ebs_volume_href="$2"
device="$3"

api_url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$server_id/current/attach_volume"
echo "[API $rs_api_version] POST: $api_url"

api_result=$(curl -s -S -v -X POST -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" \
 	-d "server[ec2_ebs_volume_href]=$ec2_ebs_volume_href" \
	-d "server[device]=$device" \
	$api_url 2>&1)

case $api_result in
    *"204 No Content"*)
		echo "EBS volume, $ec2_ebs_volume_href successfully attached to server, $server_id on $device."
		exit
    ;;
	*"EC2 error"*)
		echo "$api_result" | grep "EC2 error"
		exit 2
	;;
    *)
		echo 'Server start request failed!'
		echo "$api_result"
		exit 1
    ;;
esac