---
title: Send an SMS with Unicode
description: How to send a Unicode SMS with the Nexmo SMS API
navigation_weight: 2
---

# Sending an SMS with Unicode

Nexmo's SMS API is easy to use and supports Unicode characters too. Sign up for an account and replace the following variables in the example below:

Key | Description
-- | --
`TO_NUMBER` | The number you are sending the SMS to, for example `447700900000`.
`NEXMO_API_KEY` | You can find this in your Nexmo Dashboard.
`NEXMO_API_SECRET` | You can find this in your Nexmo Dashboard.

```building_blocks
source: '_examples/messaging/sms/send-an-sms-with-unicode'
```

## Try it out

When you run the example above, the text message will be sent to the mobile number specified with the unicode characters intact.

> Note that Unicode messages can only contain 70 characters, rather than the usual 160. There's more information about this [on the help page](https://help.nexmo.com/hc/en-us/articles/204076866-How-long-is-a-single-SMS-body-)

## Further reading

* [Concatenation and encoding for SMS](/messaging/sms/guides/concatenation-and-encoding)
* [How to send SMS messages with Node.js and Express](https://www.nexmo.com/blog/2016/10/19/how-to-send-sms-messages-with-node-js-and-express-dr/)
* [Two-way SMS for customer engagement](/tutorials/two-way-sms-for-customer-engagement)
