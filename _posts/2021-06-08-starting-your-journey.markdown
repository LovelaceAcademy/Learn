---
layout: post
title: Starting Your Journey
last_modified_at: 2021-06-08
categories:
- Getting Started
order: 2
---

Navigating any Blockchain ecosystem to figure out how to participate can be a daunting task, so we prepared this guide to help the builders and visionaries get started with Cardano. We suggest the following starting points which do a great job aggregating many useful resources:
- [Getting Started With Cardano](https://www.reddit.com/r/Cardano_ELI5/wiki/index#wiki_getting_started_with_cardano) from Reddit `r/Cardano_ELI5`
- [Essential Cardano](https://github.com/input-output-hk/essential-cardano/blob/main/essential-cardano-list.md) from the [IOHK GitHub](https://github.com/input-output-hk)
- [Cardano Developer Portal](https://developers.cardano.org/): The Official Portal for Developers

## Everyone Can Participate
It is a common misconception that Cardano has a steep learning curve and further, in-depth knowledge of Haskell/Plutus is required to be start building on Cardano. In fact, there are many roles for anyone wishing to participate and one or more of these could apply to you. 

### Investor
- Basic Investor/Trader: Holds ADA on an [exchange](https://coinmarketcap.com/currencies/cardano/markets/), prays for price appreciation 
- Network Participant: Holds ADA on a personal wallet and participates in decentralisation by staking and earning additional ADA (5% APY) every 5 days

### Community Member
- Informed Supporter: [Understands the ecosystem](https://github.com/input-output-hk/essential-cardano/blob/main/essential-cardano-list.md), uses Cardano products/services and holds [Native Assets](https://cnft.io/)
- Governance Participant - [Governance](https://cardano.org/governance/) Voter/Contributor and earns ADA voting for the future of Cardano

### Digital Creative
- Graphics or UX Designer for Cardano products/services
- NFT Content Creator 

### Builder
- Stake Pool Operator (SPO)
- DApp Developer - Builds On-chain Smart Contracts
- Integration and Infrastructure Developer - Off-chain integration pieces e.g. APIs, SDKs, CLIs, etc.
- Tooling Developer - Wallets and Utility Portals
- Analytics Developer - Block/Token/Stake Pool/Tx Explorers 

### Entrepreneur
- Founder of Cardano-based product/service

That said, Lovelace Academy as an education platform is mostly geared to the builders of Cardano so most of the subsequent content will be technical in nature. 

## What Builders Should Know
As Blockchain sits at the intersection of cryptography, computer science, distributed systems and economics beginners might be overwhelmed with the amount of knowledge required to understand each field. However, do not fear! You do not need to be such an advanced polymath to start building something on Cardano. In fact, you can already begin your journey with a basic understanding of software development.

### Key Differences vs Traditional Software Development
As a developer you might be familiar with the client-server paradigm used throughout Web 2.0 where thin clients/frontends make requests to servers managed by a trusted intermediary, and these servers sit on top of a distributed database or interact with other servers. Web3 flips that paradigm with the following key differences:

#### A Network of Full Nodes
- Everyone can run a full node, which acts as both client and server
- Every full node synchronises a full copy of the database with its peers
- Every full node validates the integrity of the data using cryptographic checks

#### Transactions and Updates
- Updates to the data come from transactions (Tx)
- Every Tx has a fee in ADA based on its content
- Every Tx propagates through the network of full nodes after submission 
- Pending Txs are batched into Blocks committed by Stake Pools at a regular interval
- Everyone can participate in the Proof-of-Stake consensus to commit Blocks (i.e. be a SPO)
- Tx finalisations are not immediate. A by-product of eventual consistency in distributed systems with additional protection against invalid forks

#### Computation and Storage
- On-chain computation (i.e. Executing Smart Contracts) has compute/time & storage/space costs 
- On-chain computation can only work with data that exists on-chain (i.e. No integration outside the Blockchain itself apart from Oracle data)
- On-chain storage of _additional_ data comes at a cost (e.g. metadata)

#### Technical Limitations?
- Benefits of decentralisation and having a trusted global network of value outweighs the raw technical limitations (e.g. limited throughput & storage)
- Scaling solutions are already on the way
- Blockchains or distributed ledgers are meant to complement, not replace traditional IT infrastructure

In Web3 architecture the distinction between frontend and backend still exists, with the backend consisting of on-chain and off-chain components while the frontend defines the UI and integration via off-chain SDKs.

Continue to [Running a Full Node ➡️](https://learn.lovelace.academy/getting-started/running-a-full-node/)