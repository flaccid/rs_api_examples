#! /bin/bash

# Warning: This script scrapes information from the RightScale dashboard (portal).  Do not use this script for production or any important purposes.  RightScale cannot guarantee this script to work now or in the future.

# rs-create-vpc.sh <rs_cloud_id> <name> <cidr_block> <instance_tenancy> <description>

# e.g. rs-create-vpc.sh 4 'Red Dwarf' "10.1.1.0/24" default 'This is a test VPC.'

# note on output: the 2nd last line is the rs vpc href returned and the last line is the aws vpc id returned (for successful runs)
# e.g. limiting the output: rs-create-vpc.sh 4 'Red Dwarf' "10.1.1.0/24" default 'This is a test VPC.' | tail -n 2

# RightScale (public) cloud IDs
#1  US-East
#2  Europe
#3  US-West
#4  Singapore 
#5  Tokyo
#6  Oregon
#7  SA-São Paulo (Brazil)

[[ ! $1 ]] && echo 'No RightScale cloud ID provided.' && exit 1
[[ ! $2 ]] && echo 'No VPC name provided.' && exit 1
[[ ! $3 ]] && echo 'No VPC CIDR block provided.' && exit 1
[[ ! $4 ]] && echo 'No VPC instance tenancy provided.' && exit 1
[[ ! $5 ]] && echo 'No VPC description provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_cloud_id="$1"
vpc_name="$2"
cidr_block="$3"
instance_tenanacy="$4"
vpc_desc="$5"

rs-login-dashboard.sh               # (run this first to ensure current session)

url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpcs"
echo "POST: $url"

api_result=$(curl -v -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" -X POST -d vpc[name]="$vpc_name" -d vpc[cidr_block]="$cidr_block" -d vpc[instance_tenancy]="$instance_tenancy" -d vpc[description]="$vpc_desc" "$url" 2>&1)

echo "$api_result" > /tmp/rs_api_examples.output.txt

if grep flash_message <<< $api_result > /dev/null 2>&1; then
     echo "$api_result" | grep flash_message | sed 's/<[^>]*>//g'
     echo "Creation of VPC '$vpc_name' failed!"
     exit 1
fi

case $api_result in
    *"302 Found"*)
        echo "VPC '$vpc_name' successfuly created."
        rs-query-cloud.sh "$rs_cloud_id"    # (optional, to refresh dash index view of the region's VPCs; just to be sure its updated)
        vpc_rs_url="$(echo "$api_result" | awk '/Location:/ { print $3 }')"     # rs href
        vpc_rs_url="${vpc_rs_url//[[:space:]]}"

        echo "$vpc_rs_url"

        # by the vpc's view
        #curl -s -b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
        #-H "X-Requested-With: XMLHttpRequest" \
        #"$vpc_rs_url" | grep vpc- | sed 's/<[^>]*>//g' | sed -e 's/.*<td>\(.*\)<\/td>.*/\1/p' | head -n 1 | sed 's/  //g'  # aws vpc ID

        # by index (inaccurate, vpc name must be unique)
        curl -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
        -H "X-Requested-With: XMLHttpRequest" \
        -H "Referer: https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpcs" \
        "https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpcs;vpcs" | grep "$vpc_name" -C 3 | grep vpc- | sed -e 's/.*<td>\(.*\)<\/td>.*/\1/p' | head -n 1 | sed 's/  //g'  # aws vpc ID
    ;;
    *)
        echo 'There appears to have been an issue creating the VPC, please check the result.'
        exit 255;
    ;;
esac
