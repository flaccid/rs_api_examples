#!/bin/bash -e

# rs-relaunch-server <server_id>

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

# Set variables
server_id="$1"

if [ ! "$server_id" ]; then
    echo 'No server ID provided, exiting.'
    exit 1
fi

## functions

# get server's operational state
server_state() {
    echo "Getting server's operational state."
	url="https://my.rightscale.com/api/acct/"$rs_api_account_id"/servers/"$server_id"/current"
	echo "GET: $url"
    state_xml=$(curl -s -H "X-API-VERSION:$rs_api_version" -b "$rs_api_cookie" "$url" | grep state) || no_state=1
	#echo "$state_xml"
    if [ ! "$no_state" ]; then
        state_xml="${state_xml#*>}"
        state="${state_xml%<*}"
        echo '  state: '"$state"
    else
        echo 'Server is not operational.'
		echo "$state_xml"
    fi
}

# terminate the server
stop_server() {
    echo 'Terminating the server.'
	url="https://my.rightscale.com/api/acct/"$rs_api_account_id"/servers/"$server_id"/stop"
	echo "GET: $url"
    stop_result=$(curl -d api_version="$rs_api_version" -b "$rs_api_cookie" -sL -w "\\n%{http_code} %{url_effective}" "$url")
	stop_code=$(tail -n1 <<< $stop_result | awk '{print $1}')
	if [[ $stop_result = *denied* ]] || [ ! "$stop_code" = "201" ]; then
		echo "response: $stop_result"
		echo 'Failed to stop server.'
		exit 1
	fi
}
# launch the server
start_server() {
    echo 'Launching the server.'
	url="https://my.rightscale.com/api/acct/"$rs_api_account_id"/servers/"$server_id"/start"
	echo "GET: $url"
    start_result=$(curl -d api_version="$rs_api_version" -b "$rs_api_cookie" -sL -w "\\n%{http_code} %{url_effective}" "$url")
    echo "$start_result"
}

wait_for_terminate() {
    echo 'Waiting for the server to terminate.'
    while sleep 25s; do
        unset state
        server_state
        ( [ ! "$state" ] || [ "$state" = 'terminated' ] ) && break    # wait for no/terminated state
        echo '.'
    done
}

# first, get the server's operational state
server_state

# terminate the server when operational only
case "$state" in
    operational|pending)
        stop_server
        wait_for_terminate
        start_server
    ;;
    decommissioning|shutting-down)
        wait_for_terminate
        start_server
    ;;
    booting)
        echo 'Server is currently booting, exiting.'
		exit
    ;;
    terminated)
        start_server    # start server on no or unknown operational state
    ;;
    *)
        echo 'Unknown server state, exiting.'
		exit 1
    ;;
esac