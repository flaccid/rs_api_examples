# !/bin/sh -e

# rs-reboot-agent.sh

# this script does not require the RightScale API; local commands are used to restart rightlink and run boot scripts

echo 'Rebooting RightScale/RightLink.'

# reboot rightscale/rightlink
/opt/rightscale/sandbox/bin/ruby /opt/rightscale/right_link/bin/rnac.rb --stop instance
service rightlink stop
service rightscale start
service rightboot start
service rightlink start