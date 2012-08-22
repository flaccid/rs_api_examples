#! /bin/bash

# rs-create-vpc-subnet.sh <rs_cloud_id> <rs_vpc_id> <subnet_name> <cidr_block> <rs_vailability_zone_id> <description>

# e.g. rs-create-vpc-subnet.sh 4 200800001 'My super secret subnet' "10.1.1.0/24" 123320 'This is a test VPC subnet.'

# RightScale EC2 AZ IDs
#123319 ap-southeast-1a
#123320 ap-southeast-1b

[[ ! $1 ]] && echo 'No RightScalecloud ID provided.' && exit 1
[[ ! $2 ]] && echo 'No RightScale VPC subnet ID provided.' && exit 1
[[ ! $3 ]] && echo 'No VPC subnet name provided.' && exit 1
[[ ! $4 ]] && echo 'No VPC CIDR block provided.' && exit 1
[[ ! $5 ]] && echo 'No RightScale availability zone id provided.' && exit 1
[[ ! $6 ]] && echo 'No VPC subnet description provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_cloud_id="$1"
rs_vpc_id="$2"
subnet_name="$3"
cidr_block="$4"
rs_availability_zone_id="$5"
subnet_desc="$6"

rs-login-dashboard.sh               # (run this first to ensure current session)

url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpc_subnets"
echo "POST: $url"

api_result=$(curl -v -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" -X POST -d vpc_subnet[vpc_id]="$rs_vpc_id" -d vpc_subnet[name]="$subnet_name" -d vpc_subnet[cidr_block]="$cidr_block" -d vpc_subnet[ec2_availability_zone_id]="$rs_availability_zone_id" -d vpc_subnet[description]="$subnet_desc" "$url" 2>&1)

echo "$api_result" > /tmp/rs_api_examples.output.txt

if grep flash <<< $api_result > /dev/null 2>&1; then
     echo "$api_result"
     echo "Creation of VPC subnet, '$subnet_name' failed!"
     exit 1
fi

case $api_result in
    *)
        #echo 'There appears to have been an issue creating the VPC, please check the result.'
        exit 0;
    ;;
esac