function get-newest-addon {
  check-addon $1 $2 | jq 'first'
}

function check-addon {
  aws eks describe-addon-versions --addon-name $1 \
    --query 'addons[*].addonVersions[*].addonVersion' \
    --kubernetes-version $2 \
    --output json | jq 'flatten'
}

function aws-profile {
  local profile=$1

  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN

  if [[ "$profile" != "" ]]; then
      export AWS_PROFILE="$profile"
  else
      export AWS_PROFILE=$(aws configure list-profiles | fzf)
  fi
}