#!/bin/bash
service_lists="["
while read -r line; do
  SERVICE_NAME_VAL=$(awk -F, '{print $1}' <<< "$line" | tr -d '[:space:]')
  VERSION=$(awk -F, '{print $2}' <<< "$line" | tr -d '[:space:]')
  if [ "$SERVICE_NAME_VAL" == "SERVICE" ]; then
    continue
  fi
  service_lists+="{\"service_name\": \"$SERVICE_NAME_VAL\", \"version\": \"$VERSION\"},"
done < "$HELM_CHART_FILE_NAME"
service_lists="${service_lists%,}"
service_lists+="]"

echo "Check service_lists."
echo $service_lists

if [ "$ENV" == "UAT" ]; then
  TEMPLATE_ID="ctp_AA48N2uQ1sNH"
elif [ "$ENV" == "PRD" ]; then
  TEMPLATE_ID="ctp_AAd8OnbKSurj"
else
  echo "Unknown ENV: $ENV"
  exit 1
fi

cat <<EOF > payload.json
{
  "msg_type": "interactive",
  "card": {
    "type": "template",
    "data": {
      "template_id": "$TEMPLATE_ID",
      "template_variable": {
        "env": "$ENV",
        "app_version": "$TAG",
        "deployer": "$GITHUB_ACTOR",
        "service_lists": $service_lists
      }
    }
  }
}
EOF

echo "===== Payload JSON ====="
cat payload.json
echo "========================"

RESPONSE=$(curl -s -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d @payload.json)

echo "Lark response: $RESPONSE"
