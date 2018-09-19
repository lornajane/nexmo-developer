curl -X POST https://api.nexmo.com/beta/messages \
  -H 'Authorization: Bearer '$JWT\
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d $'{
    "from": { "type": "whatsapp", "number": "WHATSAPP_NUMBER" },
    "to": { "type": "whatsapp", "number": "TO_NUMBER" },
    "message": {
      "content": {
        "type": "text",
        "text": "This is a WhatsApp Message sent from the Messages API"
      }
    }
  }'
