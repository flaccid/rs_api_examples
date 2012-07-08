#!/bin/sh -e

# rs-switch-state.sh [operational|booting|decommissioning|stranded]

# e.g. rs-switch-state.sh operational

[[ ! $1 ]] && echo 'No state provided.' && exit 1

state="$1"

(. /var/spool/cloud/user-data.sh || . /var/spool/ec2/user-data.sh) >/dev/null 2>&1

if ! test "${RS_API_URL+defined}"; then
  echo 'No RS_API_URL found, exiting.'
  exit 1
fi

url="$RS_API_URL/run_right_scripts/state"
echo "PUT: $url"
curl -s -S -H 'X-API-VERSION:1.0' -X PUT -d now="$state" "$url"