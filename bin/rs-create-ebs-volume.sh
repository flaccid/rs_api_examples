#!/bin/bash -e

# rs-create-ebs-volume.sh <rs_cloud_id> <nickname> <description> <ec2_availability_zone> <size_in_gigabytes> [<aws_iops>]

# e.g. rs-create-ebs-volume.sh 1 "My new EBS volume" "This is a 1GB test volume only, please remove." "us-east-1a" 1

[[ ! $1 ]] && echo 'No RS cloud ID provided, exiting.' && exit 1
[[ ! $2 ]] && echo 'No volume nickname provided, exiting.' && exit 1
[[ ! $3 ]] && echo 'No volume description provided, exiting.' && exit 1
[[ ! $4 ]] && echo 'No EC2 availability zone provided, exiting.' && exit 1
[[ ! $5 ]] && echo 'No volume size (GB) provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_cloud_id="$1"
vol_nickname="$2"
vol_desc="$3"
vol_az="$4"
vol_size="$5"

api_url="https://my.rightscale.com/api/acct/$rs_api_account_id/ec2_ebs_volumes"
echo "[API $rs_api_version] POST: $api_url"

api_result=$(curl -s -S -v -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" \
	-d "cloud_id=$rs_cloud_id" \
	-d "ec2_ebs_volume[nickname]=$vol_nickname" \
	-d "ec2_ebs_volume[description]=$vol_desc" \
	-d "ec2_ebs_volume[ec2_availability_zone]=$vol_az" \
	-d "ec2_ebs_volume[aws_size]=$vol_size" \
	"$api_url" 2>&1)

case "$api_result" in 
  *"201 Created"*)
    echo "EBS volume, '$vol_nickname' successfully created."
	echo "$api_result" | grep Location | awk '/Location:/ { print $3 }'
	exit
  ;;
  *)
    echo "EBS volume creation FAILED: $api_result"
	exit 1
  ;;
esac

echo "$api_result"