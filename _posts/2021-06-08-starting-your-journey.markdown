---
layout: post
title: Starting Your Journey
last_modified_at: 2021-06-08
categories:
- Getting Started
order: 2
---

Navigating any Blockchain ecosystem to figure out how to participate can be a daunting task, so we prepared this guide for newcomers get started with Cardano. We suggest the following starting points which do a fantastic job aggregating a multitude of useful resources:
- [**Getting Started With Cardano**](https://www.reddit.com/r/Cardano_ELI5/wiki/index#wiki_getting_started_with_cardano) from Reddit [`r/Cardano_ELI5`](https://www.reddit.com/r/Cardano_ELI5)
- [**Essential Cardano**](https://github.com/input-output-hk/essential-cardano/blob/main/essential-cardano-list.md) from the [IOHK GitHub](https://github.com/input-output-hk)
- [**Cardano Developer Portal**](https://developers.cardano.org/) The Official Portal for Developers

## Everyone Can Participate
It is a common misconception that Cardano has a steep learning curve and further, in-depth technical knowledge is required to play a role in Cardano's flourishing ecosystem. In fact, there are many roles for anyone wishing to participate and one or more of these could apply to you. 

### Investor
- Basic Investor/Trader: Holds ADA on an [exchange](https://coinmarketcap.com/currencies/cardano/markets/) and prays for price appreciation 
- Network Participant: Holds ADA on a personal wallet, participates in decentralisation through staking and earning additional ADA (approx. 5% APY) every five days

### Community Member
- Informed Supporter: [Understands the ecosystem](https://github.com/input-output-hk/essential-cardano/blob/main/essential-cardano-list.md), uses Cardano products/services and holds one or more of its [1,361,971 Native Tokens (as of Oct-2021)](https://pool.pm/tokens)
- Governance Participant: [Governance](https://cardano.org/governance/) Voter/Contributor and earns ADA voting for the future of Cardano

### Builder
- Stake Pool Operator (SPO): Manages trusted and reliable infrastructure to host a block-producing [cardano-node](https://github.com/input-output-hk/cardano-node/)
- DApp Developer: Builds On-chain Smart Contracts
- Infrastructure and Integration Developer: Builds Off-chain integration pieces e.g. APIs, SDKs, CLIs, etc.
- Utility Developer: Builds Wallets and Utility Portals
- Analytics Developer: Builds Block/Token/Stake Pool/Tx Explorers 
- NFT Content Creator: Creates Digital Media and Tokenises it as a Cardano Native Asset
- Graphics or UX Designer for Cardano products/services

With that in mind, Lovelace Academy as an education platform is mostly geared to the builders of Cardano so most of the subsequent content will be technical in nature. 

## A Paradigm Shift for Builders
As Blockchain sits at the intersection of cryptography, computer science, distributed systems and economics beginners might be overwhelmed with the amount of knowledge required to understand each field. However, do not fear! You do not need to be such an advanced polymath to start building something on Cardano. In fact, you can already begin your journey with a basic understanding of software development.

### Key Differences vs Traditional Software Development
As a developer you might be familiar with the client-server paradigm used throughout Web 2.0 where thin clients/frontends make requests to servers managed by a trusted intermediary, and these servers sit on top of distributed databases and/or interact with other servers. Web3 flips that paradigm with the following key differences:

|   | Traditional Software Development  | Blockchain  Development   |
|---|---|---|
| Ownership of Data   | Owned by the centralised corporations  | Owned by everyone participating in blockchain |
|Data Synchronization   |   |Everyone can run a full node, which acts as a server  |
|   |   | Every full node synchronises a full copy of the database with its peers  |
|   |   | Every full node validates the integrity of the data using cryptography  |
| Data Update  |   | To update data we must submit a transaction (Tx) |
|   |   | Every Tx has a fee in ADA based on its payload  |
|   |   | Everyone can submit a Tx as long as the accounting/cryptographic/smart contract validation succeeds  |
|   |   | Every Tx propagates through the network of full nodes after submission in a _pending_ state |
|   |   | Pending Txs are batched into Blocks committed by Stake Pools at a regular interval  |
|   |   | Everyone can participate in the Proof-of-Stake consensus to commit new Blocks (i.e. be a SPO)  |
|   |   | Tx finalisations are not immediate. A by-product of eventual consistency in distributed systems with additional protection against invalid forks  |
| Computation and Storage  |   | On-chain computation (i.e. Executing Smart Contracts) has compute/time & storage/space costs  |
|   |   | On-chain computation can only work with data that exists on-chain (i.e. No integration outside the Blockchain itself apart from Oracle-inserted data)  |
|   |   | On-chain storage of _additional_ data comes at a cost (e.g. metadata)  |


#### A Network of Full Nodes
- Everyone can run a full node, which acts as a server
- Every full node synchronises a full copy of the database with its peers
- Every full node validates the integrity of the data using cryptography

#### Transactions and Updates
- Updates to the data come from transactions (Tx)
- Every Tx has a fee in ADA based on its payload
- Everyone can submit a Tx as long as the accounting/cryptographic/smart contract validation succeeds
- Every Tx propagates through the network of full nodes after submission in a _pending_ state
- Pending Txs are batched into Blocks committed by Stake Pools at a regular interval
- Everyone can participate in the Proof-of-Stake consensus to commit new Blocks (i.e. be a SPO)
- Tx finalisations are not immediate. A by-product of eventual consistency in distributed systems with additional protection against invalid forks

#### Computation and Storage
- On-chain computation (i.e. Executing Smart Contracts) has compute/time & storage/space costs 
- On-chain computation can only work with data that exists on-chain (i.e. No integration outside the Blockchain itself apart from Oracle-inserted data)
- On-chain storage of _additional_ data comes at a cost (e.g. metadata)

#### Technical Limitations?
- Benefits of decentralisation and having a trusted global network of value outweighs the raw technical limitations (e.g. limited throughput & storage) of the base layer
- Scaling solutions are already on the way
- Blockchains or distributed ledgers are meant to complement, not replace traditional IT infrastructure

## Run a Full Cardano Node

Continue to [Running a Full Node ➡️](https://learn.lovelace.academy/getting-started/running-a-full-node/)