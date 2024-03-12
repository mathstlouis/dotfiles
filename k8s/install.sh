BYellow='\033[1;33m'
NC='\033[0m'

echo "${BYellow}  › Installing kubectl plugins using krew${NC}"
kubectl krew install who-can
kubectl krew install resource-capacity
kubectl krew install rbac-tool
kubectl krew install trace
