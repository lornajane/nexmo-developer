---
title: Viber Service Messages
---

# Viber Service Messages

You can use the Messages API to send outbound Viber Service Messages to Viber Users.

Viber Service Messages can only be sent by businesses that have been approved by Viber. This business profile will also have a green check to indicate that it is a legitimate business. 

The advantage of Viber Service Messages is that the identifier of users on the platform is the mobile phone number. The business accounts can also be limited to only outbound messages to the customer. This means there is no way for a customer to respond and means that you don't need 

In order to get started with Viber Service Messages you will need to email [sales@nexmo.com](mailto:sales@nexmo.com). Nexmo is an official partner and will handle the application and creation of your Viber Service Messages account for you.

If successful, your account manager will provide you with a Viber Service Messages ID. This ID can only be used on Nexmo.

## Configure your Delivery Receipt and Inbound Message endpoint with Nexmo

From [Nexmo Dashboard](https://dashboard.nexmo.com) go to [Settings](https://dashboard.nexmo.com/settings).

Set the HTTP Method to POST and enter your endpoint in the fields labeled **Webhook URL for Inbound Message** and **Webhook URL for Delivery Receipt**:

```screenshot
script: app/screenshots/webhook-url-for-inbound-message.js
image: public/assets/screenshots/dashboardSettings.png
```

## Send a message

Key | Description
-- | --
`NEXMO_APPLICATION_ID` |	The ID of the application that you created.
`VIBER_SERVICE_MESSAGE_ID` | Your Viber Service Message ID.
`TO_NUMBER` | The phone number you are sending the message to in [E.164](https://en.wikipedia.org/wiki/E.164) format. For example `447700900000`.

## Prerequisites

- *[Create an application](/concepts/guides/applications#getting-started-with-applications)*

## Generate a JWT

```curl
$ JWT="$(nexmo jwt:generate /path/to/private.key \application_id=NEXMO_APPLICATION_ID)"
$ echo $JWT
```

## Example

```tabbed_examples
config: 'messages_and_workflows_apis.messages.send-viber'
```
