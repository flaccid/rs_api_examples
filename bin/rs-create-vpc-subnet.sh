#! /bin/bash

# rs-create-vpc-subnet.sh <rs_cloud_id> <rs_vpc_id> <subnet_name> <cidr_block> <rs_ec2_availability_zone_id> <description>

# e.g. rs-create-vpc-subnet.sh 4 200800001 'FoobarSubnet' "10.1.1.0/24" 123320 'This is a test VPC subnet.'

# Warning: This script posts information to the RightScale dashboard.
# It is not recommended to use this script for production purposes. RightScale cannot guarantee this script will work now or in the future.

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

api_result=$(curl -v -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
-X POST \
-H "Referer:https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpcs/$rs_vpc_id" \
-H "User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1" \
-H "X-Prototype-Version:1.6.1" \
-H "X-Requested-With:XMLHttpRequest" \
-d vpc_subnet[vpc_id]="$rs_vpc_id" -d vpc_subnet[name]="$subnet_name" -d vpc_subnet[cidr_block]="$cidr_block" -d vpc_subnet[ec2_availability_zone_id]="$rs_availability_zone_id" -d vpc_subnet[description]="$subnet_desc" \
"$url" 2>&1)

echo "$api_result" > /tmp/rs_api_examples.output.txt

if ! grep -i 'successfully created' <<< $api_result > /dev/null 2>&1; then
     echo "$api_result" | grep X-Flash | sed 's/<[^>]*>//g'
     echo "Creation of VPC subnet, '$subnet_name' failed!"
     exit 1
fi

echo "$api_result" | grep "/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpc_subnets/" | perl -F\" -alne 'print $F[1]' | grep acct | head -n1
echo "$api_result" | grep subnet- | sed -e 's/.*<td>\(.*\)<\/td>.*/\1/p' | head -n 1 | sed 's/  //g'
