#! /bin/sh -e

# rs-rename-array-instance-hyphonated.sh <server_array_id>

# TODO: this script is currently unfinished and untested.

# Warning: This script posts information to the RightScale dashboard.
# It is not recommended to use this script for production purposes. RightScale cannot guarantee this script will work now or in the future.

# Notes: currently only supports non-EC2 arrays.
#        Ruby and Nokogiri are required for this example.

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

[ ! "$1" ] && echo 'No server array ID provided.' && exit 1

server_array_id="$1"
export SERVER_ARRAY_ID="$1"

irb <<-EORUBY

require "rubygems"
require "nokogiri"

puts ENV['SERVER_ARRAY_ID']
exit

html = system("./rs-get-array-instances-dash-html.sh", ENV['SERVER_ARRAY_ID'])
exit

html_doc = Nokogiri::HTML(html)

puts html_doc

EORUBY

exit




html body div.no_separator.tabular_data form#bulk_action_form table#server_arrays_show_instances.data_table.table_list.no_separator body tr ..

api_url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/instances/$array_instance_id/set_instance_name"

echo "[dashboard] POST: $api_url"

api_result=$(curl -X POST -v -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" -H "X-Requested-With: XMLHttpRequest" -d "name=$new_instance_name" "$api_url" 2>&1)

case $api_result in
	*"200 OK"*)
		echo "Server array instance, $array_instance_id successfuly renamed as '$new_instance_name'."
	;;
	*)
		echo "$api_result"
		echo "Server array instance rename failed!"
	;;
esac