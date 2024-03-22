function get-newest-addon {
  check-addon $1 $2 | jq 'first'
}

function check-addon {
  aws eks describe-addon-versions --addon-name $1 \
    --query 'addons[*].addonVersions[*].addonVersion' \
    --kubernetes-version $2 \
    --output json | jq 'flatten'
}