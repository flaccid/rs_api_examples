#! /bin/sh -e

# rs-create-vpc.sh <rs_cloud_id> <name> <cidr_block> <instance_tenancy> <description>
# e.g. rs-create-vpc.sh 4 'Red Dwarf VPC' 10.1.1.1/24 default 'This is a test VPC.'

# RightScale (public) cloud IDs
#1  US-East
#2  Europe
#3  US-West
#4  Singapore 
#5  Tokyo
#6  Oregon
#7  SA-São Paulo (Brazil)

[[ ! $1 ]] && echo 'No RightScale cloud I provided.' && exit 1
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

result=$(curl -v -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" -X PUT -d _=" " -d vpc[name]="$vpc_name" -d vpc[cidr_block]="$cidr_block" -d vpc[instance_tenancy]="$instance_tenancy" -d vpc[description]="$vpc_desc" "$url" 2>&1)

case $result in
	*"302 Found"*)
		echo "VPC '$2' successfuly created."
	;;
	*)
		echo "$result"
		echo "Creation of VPC, $1 failed!"
	;;
esac

rs-query-cloud.sh "$rs_cloud_id"    # (optional, to refresh dash index view of the region's VPCs)