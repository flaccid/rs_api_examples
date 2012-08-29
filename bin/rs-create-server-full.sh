#!/bin/bash -e

# Warning: This script scrapes information from the RightScale dashboard (portal).  Do not use this script for production or any important purposes.  RightScale cannot guarantee this script to work now or in the future.

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

BASE=`basename $0`

function USAGE ()
{
    echo ""
    echo "USAGE: "
    echo "    $BASE [snightpa] <nickname> <rs_cloud_id> <deployment_id> <server_template_id> <ec2_instance_type> <ec2_ssh_key_id> <vpc_subnet_id>"
    echo ""
    echo "OPTIONS:"
    echo "    -s  VPC subnet ID"
    echo "    -n  NAT enabled"
    echo "    -i  EIP ID (for VPC, use a VPC EIP) Note. This EIP will be associated at launch"
    echo "    -g  Security group ID (for VPC, use a VPC security group)"
    echo "    -t  EC2 instance type (default is 'm1.small')"
    echo "    -p  EC2 pricing ['on_demand' or 'spot']"
    echo "    -a  Set a private IP address (for a VPC subnet)"
    echo "    -h  this usage information"
    echo 
    echo "EXAMPLE:"
    echo "    $BASE -i 88888 -s 201548001 -n -g 1234 -g 5678 -i 54321 Starbug 4 281233001 252761001 m1.small 0 209585"
    echo "    This will add a server to a VPC subnet, include it into two security groups and assicate an EIP at launch"
    echo
    echo "    RightScale (public) cloud IDs"
    echo "    #1  US-East"
    echo "    #2  Europe"
    echo "    #3  US-West"
    echo "    #4  Singapore "
    echo "    #5  Tokyo"
    echo "    #6  Oregon"
    echo "    #7  SA-São Paulo (Brazil)"

    exit $E_OPTERROR    # Exit and explain usage, if no argument(s) given.
}

# Set defaults

vpc_subnet_id=
ec2_security_group_ids=
nat_enabled=
ec2_elastic_ip_id=
ec2_pricing="on_demand"  
ec2_availability_zone_id=
max_spot_price=
multi_cloud_image_id=
ec2_instance_type=m1.small
private_ip_address=

while getopts "s:ni:g:h:t:p:a:m:" Option
do
    case $Option in
	s)
		vpc_subnet_id="$OPTARG"
	;;
	n)
		nat_enabled=1
	;;
	i)
		ec2_elastic_ip_id="$OPTARG"
		[ "$ec2_elastic_ip_id" ] && associate_eip_at_launch=1
	;;
	g)
		ec2_security_group_ids="$ec2_security_group_ids $OPTARG"
	;;
	t)
		ec2_instance_type="$OPTARG" 
	;;
	p)
		ec2_pricing="$OPTARG"
	;;
	a)
		private_ip_address="$OPTARG" 
	;;
	m)
		max_spot_price="$OPTARG" 
		ec2_pricing="spot" # Force this value
	;;
        h|?)
		USAGE
		exit 0
	;;
        *|?)
		echo "Error: Unknown option $Option"
		USAGE
		exit 0
	;;
    esac
done

shift $(($OPTIND - 1))

nickname="$1"
rs_cloud_id="$2"
deployment_id="$3"
server_template_id="$4"
ec2_ssh_key_id="$6"

ari_image_uid=""
aki_image_uid=""
ec2_user_data=""
image_uid=""
ec2_placement_group_id=""

[[ ! $1 ]] && echo 'No Server nickname ID provided.' && USAGE
[[ ! $2 ]] && echo 'No RightScale cloud ID provided.' && USAGE
[[ ! $3 ]] && echo 'No RightScale deployment ID provided.' && USAGE
[[ ! $4 ]] && echo 'No RightScale ServerTemplate ID provided.' && USAGE
[[ ! $6 ]] && echo 'No EC2 SSH key ID provided.' && USAGE

# In case of multiple security groups, set up the params for curl
ec2_security_group_ids_str=
for f in $ec2_security_group_ids
do
   ec2_security_group_ids_str="-d runnable[ec2_security_group_ids][]=$f $ec2_security_group_ids_str"
done

rs-login-dashboard.sh               # (run this first to ensure current session)

url="https://my.rightscale.com/acct/$rs_api_account_id/servers"
echo "POST: $url"

#result=$(curl -v -S -s -X POST \
result=$(curl -v       -X POST \
-b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
-H "Referer:https://my.rightscale.com/acct/$rs_api_account_id/servers/new?cloud_id=$rs_cloud_id&deployment_id=$deployment_id" \
-H "User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1" \
-H "X-Prototype-Version:1.6.1" \
-H "X-Requested-With:XMLHttpRequest" \
-d server_template_id="$server_template_id" \
-d runnable[nickname]="$nickname" \
-d runnable[multi_cloud_image_id]="$multi_cloud_image_id" \
-d runnable[instance_type]="$ec2_instance_type" \
-d runnable[pricing]="$ec2_pricing" \
-d runnable[max_spot_price]="$max_spot_price" \
-d runnable[vpc_subnet_id]="$vpc_subnet_id" \
-d runnable[private_ip_address]="$private_ip_address" \
-d runnable[nat_enabled]="$nat_enabled" \
-d runnable[ec2_ssh_key_id]="$ec2_ssh_key_id" \
-d runnable[ec2_elastic_ip_id]="$ec2_elastic_ip_id" \
-d runnable[associate_eip_at_launch]="$associate_eip_at_launch" \
$ec2_security_group_ids_str \
-d runnable[ec2_availability_zone_id]="$ec2_availability_zone_id" \
-d runnable[ec2_placement_group_id]="$ec2_placement_group_id" \
-d runnable[image_uid]="$image_uid" \
-d cloud_id="$rs_cloud_id" \
-d runnable[server_template_id]="$server_template_id" \
-d runnable[deployment_id]="$deployment_id" \
-d stage_names[]="ServerTemplate" \
-d stage_names[]="Server Details" \
-d stage_names[]="Confirm" \
-d runnable[image_uid]="$image_uid" \
-d runnable[ari_image_uid]="$ari_image_uid" \
-d runnable[aki_image_uid]="$aki_image_uid" \
-d runnable[ec2_user_data]="$ec2_user_data" \
-d _=" " \
"$url" 2>&1)

echo "$result" > /tmp/rs_api_examples.output.txt

echo "$result"



# Example params:
# server_template_id:252761001
# runnable[nickname]:RightScale Linux Server RL 5.8
# runnable[multi_cloud_image_id]:
# runnable[instance_type]:
# runnable[pricing]:on_demand
# runnable[max_spot_price]:0.025
# runnable[vpc_subnet_id]:
# runnable[private_ip_address]:
# runnable[nat_enabled]:0
# runnable[ec2_ssh_key_id]:298336
# runnable[ec2_elastic_ip_id]:
# runnable[associate_eip_at_launch]:0
# runnable[ec2_security_group_ids][]:261902
# runnable[ec2_security_group_ids][]:261903
# runnable[ec2_availability_zone_id]:
# runnable[ec2_placement_group_id]:
# runnable[image_uid]:
# runnable[ari_image_uid]:
# runnable[aki_image_uid]:
# runnable[ec2_user_data]:
# cloud_id:4
# runnable[server_template_id]:252761001
# runnable[deployment_id]:28079

