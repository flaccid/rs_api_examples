#! /bin/bash

# rs-create-ec2-security-group.sh <rs_cloud_id> <aws_group_name> <aws_description> <scope> <rs_vpc_id>

# e.g. rs-create-ec2-security-group.sh 4 'UberSecure' 'This is just a test security group' vpc 200634001

# Warning: This script posts information to the RightScale dashboard.
# It is not recommended to use this script for production purposes. RightScale cannot guarantee this script will work now or in the future. 

[[ ! $1 ]] && echo 'No RightScale cloud ID provided.' && exit 1
[[ ! $2 ]] && echo 'No security group name provided.' && exit 1
[[ ! $3 ]] && echo 'No security group description provided.' && exit 1
[[ ! $4 ]] && echo 'No scope provided.' && exit 1
[[ ! $5 ]] && echo 'No RightScale VPC ID provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_cloud_id="$1"
aws_group_name="$2"
aws_description="$3"
scope="$4"
rs_vpc_id="$5"

url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/ec2_security_groups"
echo "POST: $url"

api_result=$(curl -v -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
-X POST \
-H "Referer:https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpcs/$rs_vpc_id" \
-H "User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1" \
-H "X-Prototype-Version:1.6.1" \
-H "X-Requested-With:XMLHttpRequest" \
-d ec2_security_group[aws_group_name]="$aws_group_name" -d ec2_security_group[aws_description]="$aws_description" -d ec2_security_group[scope]="$scope" -d ec2_security_group[vpc_id]="$rs_vpc_id" \
"$url" 2>&1)

echo "$api_result" > /tmp/rs_api_examples.output.txt

if ! grep -i 'successfully created' <<< $api_result > /dev/null 2>&1; then
     echo "$api_result" | grep X-Flash | sed 's/<[^>]*>//g'
     echo "Creation of EC2 Security Group, '$aws_group_name' failed!"
     exit 1
fi

echo "$api_result" | grep "/acct/$rs_api_account_id/clouds/$rs_cloud_id/ec2_security_groups/" | perl -F\" -alne 'print $F[1]' | grep acct | head -n1
#echo "$api_result" | grep - | sed -e 's/.*<td>\(.*\)<\/td>.*/\1/p' | head -n 1 | sed 's/  //g'
