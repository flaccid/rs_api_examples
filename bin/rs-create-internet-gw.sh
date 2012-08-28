#!/bin/bash -e

# rs-internet-gateway.sh <nickname> <rs_cloud_id> <vpc_id>

# e.g. rs-create-server.sh  my_gw 2 123456

# RightScale (public) cloud IDs
#1  US-East
#2  Europe
#3  US-West
#4  Singapore 
#5  Tokyo
#6  Oregon
#7  SA-São Paulo (Brazil)

# Example params:

[[ ! $1 ]] && echo 'No Server nickname provided.' && exit 1
[[ ! $2 ]] && echo 'No RightScale cloud ID provided.' && exit 1
[[ ! $3 ]] && echo 'No VPC ID provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

nickname="$1"
rs_cloud_id="$2"
vpc_id="$3"

rs-login-dashboard.sh               # (run this first to ensure current session)

url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpc_internet_gateways"
echo "POST: $url"

#-H "User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1" \
#-H "X-Prototype-Version:1.6.1" \
#-H "X-Requested-With:XMLHttpRequest" \

result=$(curl -v       -X POST \
-b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
-H "Referer:https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpc_internet_gateways" \
-d _=" " \
"$url" 2>&1)

echo "$result" > /tmp/rs_gw_create.txt

echo -e "$result" | grep -q -e "^< Status: 302" && echo "Create internet gateway succeeded!"

gateway_id=`echo -e "$result" | grep "^< Location" | sed 's@^.*vpc_internet_gateways/\([0-9]*\).*@\1@'`
echo gateway_id=$gateway_id

######################
# Set nickname for Internet GW

#Request URL:https://my.rightscale.com/acct/44134/clouds/4/vpc_internet_gateways/633001/set_vpc_internet_gateway_name
url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpc_internet_gateways/$gateway_id/set_vpc_internet_gateway_name"
echo "POST: $url"

result=$(curl -v       -X POST \
-b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
-H "Referer:https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpc_internet_gateways/$gateway_id" \
-d value="$nickname" \
-d _=" " \
"$url" 2>&1)

echo -e "$result" | grep -q -e "^< Status: 200" && echo "Set nickname of gateway succeeded!"

echo "$result" > /tmp/rs_gw_set_name.txt

######################
# Associate int gw with vpc

url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpc_internet_gateways/$gateway_id/attach"
echo "POST: $url"

#-H "User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1" \

result=$(curl -v       -X POST \
-b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
-H "Referer:https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpc_internet_gateways/$gateway_id/pre_attach" \
-d _method=put \
-d vpc_internet_gateway[vpc_id]=$vpc_id \
-d _=" " \
"$url" 2>&1)

echo -e "$result" | grep -q -e "^< Status: 302" && echo "Attach internet gateway succeeded!"

echo "$result" > /tmp/rs_gw_attach_vpc.txt

