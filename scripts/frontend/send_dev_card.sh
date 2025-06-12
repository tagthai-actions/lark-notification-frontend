#!/bin/bash
cat <<EOF > payload.json
{
  "msg_type": "interactive",
  "card": {
    "type": "template",
    "data": {
      "template_id": "ctp_AA4OuaEvBdMQ",
      "template_variable": {
        "env": "DEV",
        "service_name": "$SERVICE_NAME",
        "deployer": "$GITHUB_ACTOR",
        "version": "$REF",
        "service_url": "https://github.com/$GITHUB_REPOSITORY",
        "commit_messages": $COMMIT_MESSAGES
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
        