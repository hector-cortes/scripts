#!/bin/bash
# Generates an AWS CLI config file using account information output from
# the AWS CLI list-accounts command

set -o nounset  # abort on unbound variable
set -o errexit  # abort on nonzero exitstatus
set -o pipefail # don't hide errors within pipes

account_info=()
while IFS='' read -r line; do
  account_info+=("$line") 
done < <(aws organizations list-accounts --output json | jq ".Accounts[] | (.Id, .Name)")

while read -r id name; do
  cat << EOF >> config
  [profile ${name}]
  source   = default
  role_arn = arn:aws:iam::${id}:role/OrganizationalAccountAccessRole

EOF
done < <(echo "${account_info[@]}"| xargs -n2)
