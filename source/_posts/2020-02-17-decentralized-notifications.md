title: Supporting Email Notifications in DApps
author: richard_ramos
summary: "Adding Email Notifications to dapps using a decentralized infrastructure"
categories:
  - dapp-development
  - tools
layout: blog-post
image: '/assets/images/embark-header_blank.jpg'
---

Supporting Email Notifications in DApps
===

Having notifications is important when the flow of your dapp is asynchronous, especially if funds are involved. As such, depending on having the user browse the dApp periodically to see if there was a change does not lead to a good user experience. 

Users need to know that an action happened and their interaction with a smart contract might be necessary.

In Teller.Exchange, a decentralized fiat on-ramp and off-ramp, this situation happens: sellers need to be notified that a new trade was created, buyers need to know if their escrows were funded or released, and arbitrators want to know if they have a dispute to arbitrate.

Using browser notifications are not really a solution since most users ignore these, as well as not being available in all browsing devices. So using emails were a good alternative to solve this need, yet it must be in compliance with the Status.im principles being `Privacy` one that could be affected if we make the email notifications being a requirement for the use of Teller.Exchange

```
IV. Privacy
Privacy is the power to selectively reveal oneself to the world. For us, it's essential to protect privacy in both communications and transactions, as well as being a pseudo-anonymous platform. Additionally, we strive to provide the right of total anonymity.
```

Teller.Exchange was built with the idea of not requiring servers for the backend. It consists of a Frontend (HTML+JS+CSS) and this frontend interacts directly with the smart contracts, without being limited by the requirements of using centralized servers like databases, as well as minimizing the use of external APIs.

In the constant search for a balance between good UI and adhering to decentralization principals tradeoffs must be made. In order to comply with the Status Principles as well as the architecture requirements, we came up with a solution: an opt-in contract event notifier.

### How does it work?

The process is relatively straight forward. In the DApp, an user enters their email, signs it using their web3 provider of choice, and then submits this information to our notifier API, associating their ETH address with an email address of their choosing. Good OpSec is of course to create a new email with no personally identifiable information, however that is entirely up to the user.

After their signature is submitted, the user will receive a verification email, and then get a notification anytime a teller transaction involving their ETH account is confirmed on the network. 

For those who make a living buying and selling crypto this is a useful service for tax reporting purposes. In our system this is an entirely voluntary process for users but you can choose how you want to integrate it into your application.

### The architecture

The notifier is composed of an API and a backend service. The API allows the user to subscribe to notifications (which sends an email containing a token), verify their email by sending the token generated during subscription, as well as unsubscribing from this service.

The user address and email are stored in a mongodb collection. Although this is a centralized service, since it's opt-in, a savvy user might be able to setup and run their own instance of the backend service and this way their email address is not shared with us.

The backend service keeps track of all the events being generated in the smart contracts it watches. After a number of confirmations is reached (to avoid possible reorgs), the notification service will read the configuration for the events that were generated, prepare the email content by using templates as well as the information available in the smart contracts and send emails to the accounts involved in the transactions.

Both the API and service can be configured via a json file where the developer needs to set the contract addresses to watch, templates associated individual contract events, as well as filters to determine whether an event should be sent to an user or not.

Here's an example of an event we have configured in our contract notifier. It tracks the event `Released(uint indexed escrowId, address indexed seller, address indexed buyer, bool isDispute)`, which is emitted when an escrow is released successfully (this happens when a trade goes well, or if a dispute is won by the buyer):

```js
...
["0xD5baC31a10b8938dd47326f01802fa23f1032AeE"]: {
  "dispute-won-buyer": {
    ABI: {
      name: "Released",
      type: "event",
      inputs: [
        { indexed: true, name: "escrowId", type: "uint256" },
        { indexed: true, name: "seller", type: "address" },
        { indexed: true, name: "buyer", type: "address" },
        { indexed: false, name: "isDispute", type: "bool" }
      ]
    },
    index: "buyer",
    filter: async (web3, returnValues) => returnValues.isDispute,
    template: "dispute-won-buyer.md"
  },
  ...
}
...
```

Setting up this event requires specifying the ABI, and an index to associate the user address to an event parameter. In this example the index is the `buyer`, which means that the event will verify if the `buyer` parameter matches an address stored in the mongodb collection.

Afterwards, if there's a match, we can apply an additional `filter`. We can use this filter to add extra conditions to determine if an email needs to be sent. You have access in this filter to the `web3` object as well as the return values from the event. In our example we check if the `Release` was emitted due to a dispute (because we are only interested in the escrow releases product of an arbitration).

Finally, there's a template file, which is used to prepare the email content. Here's an example of how they look:
```
---
subject: You won the dispute!
---
Congratulations, you have just won the dispute. 
The trade is now completed. 
Enjoy your crypto. 
[See the trade]({{url}}/#/escrow/{{escrowId}})
```

The templates can contain variables coming from the event return values, as well as extra data that can be specified in the config file (which can include calls to other smart contracts).

This configuration is easy to extend and we are considering using this service for other dApps we are building here at Status.im

### Using the notification service

Putting this service into practice for your application requires you to have a Sendgrid account. Other dependencies include NodeJS, Yarn and MongoDB installed. For instructions on how to install this application checkout our repository for creating this service for your own application: https://github.com/status-im/contract-notifier

The ethos of the Embark and other Status Network companies is to always build services for the public good. In that spirit we decided to make our smart contract notification service freely available to anyone interested in using it. This is an open source project and we welcome pull requests or issues to make it better.
