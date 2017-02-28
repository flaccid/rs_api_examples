# !/bin/bash -e

# rs-config-api.sh

mkdir -p "$HOME/.rightscale"
touch "$HOME/.rightscale/rs_api_config.sh"
touch "$HOME/.rightscale/rs_api_creds.sh"
. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

# functions
asksure() {
	echo "are you sure (y/n)? "
	while read -r -n 1 -s answer; do
  		if [[ $answer = [YyNn] ]]; then
    		[[ $answer = [Yy] ]] && retval=0
    		[[ $answer = [Nn] ]] && retval=1
    		break
  		fi
	done
	return $retval
}

read -rp 'rightscale username: ' rs_api_user
	until [[ $rs_api_user ]]
	do read -rp 'requires a value, try again: ' rs_api_user
done

read -rsp 'rightscale password [optional]: ' rs_api_password
	until [[ $rs_api_password ]]
	do read -rp 'requires a value, try again: ' rs_api_password
done
echo

read -rsp 'rightscale oauth refresh token [optional]: ' rs_api_refresh_token
echo

read -rp 'rightscale account id: ' rs_api_account_id
	until [[ $rs_api_account_id ]]
	do read -rp 'requires a value, try again: ' rs_api_account_id
done

read -rep 'rightscale endpoint host:
    -> this is also known as a shard.
    -> see http://docs.rightscale.com/api/general_usage.html
    -> all accounts reside on a specific shard, e.g. us-3.rightscale.com : ' rs_server
	until [[ $rs_server ]]
	do read -rp 'requires a value, try again: ' rs_server
done

read -rp 'rightscale api version, e.g. 1.5 : ' rs_api_version
	until [[ $rs_api_version ]]
	do read -rp 'requires a value, try again: ' rs_api_version
done

# confirmation
clear
echo
echo '== confirmation =='
echo "user: $rs_api_user"
[ ! -z "$rs_api_password" ] && echo "password: <hidden>"
[ ! -z "$rs_api_refresh_token" ] && echo "oauth refresh token: <hidden>"
echo "account id: $rs_api_account_id"
echo "endpoint/shard: $rs_server"
echo "api version: $rs_api_version"
echo "=="
echo

# ask if ok to save
echo 'is this correct?'
if asksure; then
	cat <<EOF> "$HOME/.rightscale/rs_api_config.sh"
rs_api_cookie="$HOME/.rightscale/rs_api_cookie.txt"
: \${rs_api_version:=$rs_api_version}
: \${rs_server:=$rs_server}
EOF
	cat <<EOF> "$HOME/.rightscale/rs_api_creds.sh"
rs_api_account_id=$rs_api_account_id
rs_api_user="$rs_api_user"
rs_api_password="$rs_api_password"
EOF
	[ ! -z "$rs_api_refresh_token" ] && echo "rs_api_refresh_token=$rs_api_refresh_token" >> "$HOME/.rightscale/rs_api_creds.sh"
	echo 'settings saved.'
else
	echo "operation cancelled."
fi
