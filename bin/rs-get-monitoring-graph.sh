#!/bin/bash -e

# rs-get-monitoring-graph.sh <graph_name> <server_id> <period> <title> <size> <timezone>

# example: rs-get-monitoring-graph.sh 1234 cpu-0/cpu_overview "CPU Overview" day large "Australia/Sydney"

[[ ! $1 ]] && echo 'No server ID provided, exiting.' && exit 1
[[ ! $2 ]] && echo 'No graph name provided, exiting.' && exit 1
[[ ! $3 ]] && echo 'No title ID provided, exiting.' && exit 1
[[ ! $4 ]] && echo 'No period provided, exiting.' && exit 1
[[ ! $5 ]] && echo 'No size ID provided, exiting.' && exit 1
[[ ! $6 ]] && echo 'No timezone provided, exiting.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_api_version="1.0"		# ensure API 1.0

server_id="$1"
graph_name="$2"
title="$3"
period="$4"
size="$5"
timezone="$6"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers/$server_id/monitoring/$graph_name"
echo "GET: $url"

xml=$(curl -s -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" -X GET -d period="$period" -d title="$title" -d size="$size" -d tz="$timezone" "$url")

echo "$xml"