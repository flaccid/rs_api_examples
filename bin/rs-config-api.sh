# !/bin/bash -e

# rs-config-api.sh

mkdir -p "$HOME/.rightscale"
touch "$HOME/.rightscale/rs_api_config.sh"
touch "$HOME/.rightscale/rs_api_creds.sh"
. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

# functions
asksure() {
	echo "Are you sure (Y/N)? "
	while read -r -n 1 -s answer; do
  		if [[ $answer = [YyNn] ]]; then
    		[[ $answer = [Yy] ]] && retval=0
    		[[ $answer = [Nn] ]] && retval=1
    		break
  		fi
	done
	return $retval
}

read -rp 'RightScale Username: ' rs_api_user
	until [[ $rs_api_user ]]
	do read -rp 'Requires a value, try again: ' rs_api_user
done

read -rp 'RightScale Password: ' rs_api_password
	until [[ $rs_api_password ]]
	do read -rp 'Requires a value, try again: ' rs_api_password
done

read -rp 'RightScale Account ID: ' rs_api_account_id
	until [[ $rs_api_account_id ]]
	do read -rp 'Requires a value, try again: ' rs_api_account_id
done

read -rp 'RightScale API Version (e.g. 1.0): ' rs_api_version
	until [[ $rs_api_version ]]
	do read -rp 'Requires a value, try again: ' rs_api_version
done

# confirmation
clear
echo
echo '== Confirmation =='
echo "User: $rs_api_user"
echo "Password: <hidden>"
echo "Account ID: $rs_api_account_id"
echo "API Version: $rs_api_version"
echo "=="
echo

# ask if ok to save
echo 'Is this correct?'
if asksure; then
cat <<EOF> "$HOME/.rightscale/rs_api_config.sh"
rs_api_cookie="$HOME/.rightscale/rs_api_cookie.txt"
: \${rs_api_version:=$rs_api_version}
EOF
cat <<EOF> "$HOME/.rightscale/rs_api_creds.sh"
rs_api_account_id=$rs_api_account_id
rs_api_user="$rs_api_user"
rs_api_password="$rs_api_password"
EOF
	echo 'Settings saved.'
else
	echo "operation cancelled."
fi