---
layout: post
title: Summary of Components and Options
last_modified_at: 2021-11-18
categories:
- Integrating Cardano
order: 1
---

So far, all of our interaction with Cardano has been through the `cardano-cli` and a locally running `cardano-node`. While it is perfectly fine for one-off tasks and goals, building products/protocols which require complex interactions entirely in a scripting languages will prove difficult to maintain and scale. 

## A Birds Eye View
![](/img/node_cardano_components_version_main.png)
Image courtesy of [Cardano docs](https://docs.cardano.org/explore-cardano/cardano-architecture/overview#gatsby-focus-wrapper)

🚧 _Thorough Overview Diagram coming soon_

With `cardano-node` as the centrepiece, there are many downstream components utilising the [node-to-client protocol](https://docs.cardano.org/explore-cardano/cardano-network/networking-protocol#node-to-clientipcoverview) to 
 - Perform ad-hoc queries through the `local-state-query` mini-protocol
 - Submit transactions via the `local-tx-submission` mini-protocol 
 - Propagate, consume and persist chainDB data through the `chain-sync` mini-protocol

 ## Typical Use-cases
🚧 _More content coming soon_

 ## Self-hosted vs External APIs
🚧 _More content coming soon_
