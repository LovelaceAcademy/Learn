---
layout: post
title: Summary of Components 
last_modified_at: 2021-11-18
categories:
- Integrating Cardano
order: 1
---

So far, all of our interaction with Cardano has been through the `cardano-cli` and a locally running `cardano-node`. While it is perfectly fine for one-off tasks and goals, building complex products/protocols entirely in a scripting languages will prove difficult to maintain and scale. Further, most developers are far more productive building in their preferred languages and ecosystems.

## A Birds Eye View
![](/img/node_cardano_components_version_main.png)
Image courtesy of [Cardano docs](https://docs.cardano.org/explore-cardano/cardano-architecture/overview#gatsby-focus-wrapper)

🚧 _Thorough Overview Diagram coming soon_

As described in our earlier post [Running a Full Cardano Node](https://learn.lovelace.academy/getting-started/running-a-full-node/#background), through a set of bespoke protocols the `cardano-node` serves as the main integration point to many downstream components utilising the [node-to-client protocol](https://docs.cardano.org/explore-cardano/cardano-network/networking-protocol#node-to-clientipcoverview). These downstream components can:

 - Perform ad-hoc queries through the `local-state-query` mini-protocol
   * [cardano-cli](https://github.com/input-output-hk/cardano-node/tree/master/cardano-cli)
   * [ogmios](https://github.com/cardanosolutions/ogmios)
   * [cardano-wallet](https://github.com/input-output-hk/cardano-wallet)
 - Submit transactions via the `local-tx-submission` mini-protocol 
   * [cardano-cli](https://github.com/input-output-hk/cardano-node/tree/master/cardano-cli)
   * [ogmios](https://github.com/cardanosolutions/ogmios)
   * [cardano-wallet](https://github.com/input-output-hk/cardano-wallet)
 - Propagate, consume and persist chainDB data through the `chain-sync` mini-protocol
   * [cardano-wallet](https://github.com/input-output-hk/cardano-wallet)
   * [db-sync](https://github.com/input-output-hk/cardano-db-sync)

Over the course of our Getting Started content, our guides made use of the first two mini-protocols using the `cardano-cli` to query the chain and submit our transactions. We will touch on the third `chain-sync` protocol in our following post on [querying the chain](#advanced-queries-for-cardano).

For many developers the biggest hurdle with integration stems from the fact that these `cardano-node` specific protocols are not meant for external public consumption, and even direct internal consumption can be difficult if you are not familiar with Haskell. Luckily there are two options - you can either host your own pipeline of components to integrate with Cardano **or** rely on community-built SDKs and external hosted APIs.

## Self-hosted vs External APIs
🚧 _More content coming soon_

## Use-cases
### ECommerce
1. A store creates and manages sets of keys to generate payment addresses to receive payments for orders
2. A customer creates and manages their own set of keys and addresses through their wallet(s)
3. The store listens for customer payments at their payment addresses 
4. The customer submits a transaction as a payment to the store's given address with additional metadata of purchase
4. For every valid payment the store will create and process an order in their (off-chain) systems
5. The store either 
  * Records a successful order on-chain via a new transaction with metadata
  * Refunds the payment back to the customer if it cannot be fulfilled

🚧 _More content coming soon_

## Advanced Queries for Cardano
Continue to **[Querying the Chain ➡️](https://learn.lovelace.academy/integrating-cardano/querying-the-chain/)**