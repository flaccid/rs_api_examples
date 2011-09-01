# !/bin/sh -e

# rs-reboot-agent.sh <server_id>

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

echo 'Rebooting RightScale/RightLink.'

# reboot rightscale/rightlink
/opt/rightscale/right_link/scripts/rnac.rb --stop instance
service rightlink stop
service rightscale start
service rightboot start
service rightlink start