---
title: Signing requests
description: Add an extra layer of security by sending and receiving signed requests.
---

# Signing requests

Signatures validate the authenticity of the person who interacts with Nexmo.

You use a signature to:

* Verify that a request originates from a trusted source
* Ensure that the message has not been tampered with en-route
* Defend against interception and later replay

A signature is the [MD5 hash](https://en.wikipedia.org/wiki/MD5) of:

* The parameters - all the parameters in a request sorted in alphabetic order
* A timestamp - a UNIX timestamp at UTC + 0 to protect against replay attacks
* Your `SIGNATURE_SECRET` - the key supplied by Nexmo that you use to sign or validate requests

The signature has a leading `&`. All parameters in the hash input, apart from your `SIGNATURE_SECRET` are separated by `&`.

[HMAC-SHA1/256/512 ](https://en.wikipedia.org/wiki/SHA-2) is also supported. Contact support@nexmo.com for more information.

> Note: Using signatures is an *optional* improvement on using the standard `api_secret`. You use the `SIGNATURE_SECRET` instead of your api_secret in a signed request.

The following example shows a signed request to the SMS API:

```
https://rest.nexmo.com/sms/xml?api_key=API_KEY&from=Nexmo&to=447700900000&type=text&text=Hello+from+Nexmo&status-report-req=false&timestamp=1461605396&sig=SIGNATURE
```

The workflow for using signed messages is:

![Signing requests workflow](/assets/images/workflow_call_api_outbound.svg)

1. Create a signed [request](/api/sms#request) to send an SMS.
2. Check the [response codes](/api/sms#status-codes) and ensure that you sent the request correctly.
3. Your message is delivered to the handset. The user's handset returns a delivery receipt.
4. If you requested signed delivery receipts and inbound messages validate the signature.

## Setting up message signing

To setup message signing:

1. Contact <support@nexmo.com> and request message signing. The options are:

  * Outbound messages can be signed.
  * Outbound messages must be signed.
  * Inbound messages and DLRs sent to your webhook endpoint are signed.

2. Nexmo supplies you with the `SIGNATURE_SECRET` you use to encode and decode signatures.

    > Note: this is not your `api_secret`.

3. Implement the message signing workflow.

## Implementing the message signing workflow

To sign your messages:

1. Create a signed [request](/api/sms#request):

    ```tabbed_examples
    source: '_examples/messaging/signing-messages/create-request'
    ```

2. Check the [response codes](/api/sms#response-codes) to ensure that you sent the request to Nexmo correctly:

    ```tabbed_examples
    source: '_examples/messaging/signing-messages/check-response'
    ```

    If you did not generate the signature correctly the [status](/api/sms#status-codes) is `14, invalid signature`

3. Your message is delivered to the handset. The user's handset returns a delivery receipt.

4. If your delivery receipts and inbound messages are signed, validate the signature:

    ```tabbed_examples
    source: '_examples/messaging/signing-messages/validate-signature'
    ```
