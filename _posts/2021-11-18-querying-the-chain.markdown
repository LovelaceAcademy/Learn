---
layout: post
title: Querying the Chain
last_modified_at: 2021-11-18
categories:
- Integrating Cardano
order: 2
---

As mentioned previously in the [Summary of Components](https://learn.lovelace.academy/integrating-cardano/summary-of-components/), using `cardano-cli` can be difficult to maintain and scale especially if output formats change with newer versions. Further, the ad-hoc querying options in `cardano-cli` are limited to querying the tip of the chain, basic UTxOs and protocol/stake/pool info.

## Cardano db-sync

A core component in Cardano is **[cardano-db-sync](https://github.com/input-output-hk/cardano-db-sync)**, a required dependency for almost all components supporting advanced queries over Cardano. This includes [cardano-graphql](https://github.com/input-output-hk/cardano-graphql), [cardano-rosetta](https://github.com/input-output-hk/cardano-rosetta), [SMASH API](https://github.com/input-output-hk/smash), [Dandelion APIs](https://dandelion.link/), [Blockfrost](https://blockfrost.io/) and [Koios](https://api.koios.rest/).

🚧 _More content coming soon_

## External HTTP APIs

### Koios 
🚧 _More content coming soon_

### Blockfrost
🚧 _More content coming soon_

### Cardano GraphQL (Dandelion hosted)
🚧 _More content coming soon_

## Building Cryptographic Entities
To see your options for building keys, addresses and other cryptographic entities continue to **[Building Cryptographic Entities ➡️](https://learn.lovelace.academy/integrating-cardano/building-cryptographic-entities/)**