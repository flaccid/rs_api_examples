#!/bin/bash -e

# rs-create-alert-spec.sh

# e.g. rs-create-alert-spec MyServer processes-java/ps_count processes '>' '25.0' critical 60 ServerTemplate escalate

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

rs_api_version="1.0"		# ensure API 1.0

# Mandatory params
# [name]: Nickname of the server
# [file]: File used for the alert specification
# [variable]: Variable used for the alert specification
# [condition]: Condition to use for a comparison to the threshold
# [threshold]: Threshold before the alert escalates
# [escalation_name]: Name of the escalation
# [duration]: Duration in minutes
# [subject_type]: type of the subject on which the alert should be created (‘Server’ or ‘ServerTemplate’)
# [action]: can be one of ‘escalate’ or ‘vote’

# Optional params
# [vote_type]: vote type(should be one of ‘grow’ or ‘shrink’) that will be set when the alert is triggered (ignored if the ‘action’ parameter is not set to ‘vote’)
# [vote_tag]: the tag that will be set when the alert is triggered (ignored if the ‘action’ parameter is not set to ‘vote’)
# [subject_href]: href of the subject
# [description]: Description of the alert specification

post_options=()
post_options[1]=name
post_options[2]=file
post_options[3]=variable
post_options[4]=condition
post_options[5]=threshold
post_options[6]=escalation_name
post_options[7]=duration
post_options[8]=subject_type
post_options[9]=action
post_options[1]=vote_type
post_options[1]=vote_tag
post_options[1]=subject_href
post_options[1]=description

url="https://my.rightscale.com/api/acct/$rs_api_account_id/alert_specs"
echo "POST: $url"

num_opt=0
for opt in "$@"; do
  (( ++num_opt ))
  #echo "post_options[$num_opt] : $opt"
  param=${post_options[$num_opt]}
  #echo "Param: $param"
  post_params+=" -d params[$param]=$opt"
done

#echo "Total options: $num_opt."
#echo "Post params: $post_params."

api_result=$(curl -s -S -H "X-API-VERSION: $rs_api_version" -b "$rs_api_cookie" $post_params "$url")

echo "$api_result"