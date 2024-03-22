function check-addon {
  aws eks describe-addon-versions --addon-name $1 \
    --query 'addons[*].addonVersions[*].addonVersion' \
    --kubernetes-version $2 \
    --output table
}