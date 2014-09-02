#!/bin/sh -e

# rs-create-saml-user.sh

[ ! "$1" ] && echo 'No email address provided.' && exit 1
[ ! "$2" ] && echo 'No company name provided.' && exit 1
[ ! "$3" ] && echo 'No first name provided.' && exit 1
[ ! "$4" ] && echo 'No last name provided.' && exit 1
[ ! "$5" ] && echo 'No phone provided.' && exit 1
[ ! "$6" ] && echo 'No identity provider href provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

email="$1"
company="$2"
first_name="$3"
last_name="$4"
phone="$5"
identity_provider_href="$6"
principal_uid="$email"

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

url="https://$rs_server/api/users"
echo "POST: $url"

api_result=$(curl -s -S -i -H X_API_VERSION:1.5 -H "Authorization: Bearer $rs_access_token" -X POST \
	-d user[email]="$email" \
	-d user[company]="$company" \
	-d user[phone]="$phone" \
	-d user[first_name]="$first_name" \
	-d user[last_name]=Doe \
	-d user[identity_provider_href]="$identity_provider_href" \
	-d user[principal_uid]="$email" \
	"$url" 2>&1)

echo "$api_result"
