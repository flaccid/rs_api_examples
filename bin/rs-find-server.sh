#!/bin/sh -e

# rs-find-server.sh <server_nickname>

[[ ! $1 ]] && echo 'No server nickname provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

urlencode() {
    local l=${#1}
    for (( i = 0 ; i < l ; i++ )); do
        local c=${1:i:1}
        case "$c" in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            ' ') printf + ;;
            *) printf '%%%X' "'$c"
        esac
    done
}

urldecode() {
    local data=${1//+/ }
    printf '%b' "${data//%/\x}"
}

nick_filter="$(urlencode "$1")"

url="https://my.rightscale.com/api/acct/$rs_api_account_id/servers?filter=nickname=$nick_filter"

echo "GET: $url"

api_result=$(curl -s -S -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" "$url" 2>&1)

case "$api_result" in 
  *xml\ version*)
    echo "$api_result"
    exit
  ;;
  *)
    echo "FAILED: $api_result"
    exit 1
  ;;
esac