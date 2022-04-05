---
layout: post
title: Starting Your Journey
last_modified_at: 2021-11-16
categories:
- Getting Started
order: 2
---

Navigating any Blockchain ecosystem to figure out how to participate can be a daunting task, so we prepared this guide for newcomers get started with Cardano. We recommend the following starting points which do a fantastic job aggregating a multitude of useful resources:
- [**Getting Started With Cardano**](https://www.reddit.com/r/Cardano_ELI5/wiki/index#wiki_getting_started_with_cardano) from Reddit [`r/Cardano_ELI5`](https://www.reddit.com/r/Cardano_ELI5)
- [**Essential Cardano**](https://github.com/input-output-hk/essential-cardano/blob/main/essential-cardano-list.md) from the [IOHK GitHub](https://github.com/input-output-hk)
- [**Cardano Developer Portal**](https://developers.cardano.org/) The Official Portal for Developers

## Everyone Can Participate
It is a common misconception that Cardano has a steep learning curve and further, in-depth technical knowledge is required to play a role in Cardano's flourishing ecosystem. In fact, there are many roles for anyone wishing to participate and one or more of these could apply to you. 

### Investor
- Basic Investor/Trader: Holds ADA on an [exchange](https://coinmarketcap.com/currencies/cardano/markets/) and prays for price appreciation 
- Network Participant: Holds ADA on a personal wallet, participates in decentralisation through staking and earning additional ADA (approx. 5% APY) every five days

### Community Member
- Informed Supporter: [Understands the ecosystem](https://github.com/input-output-hk/essential-cardano/blob/main/essential-cardano-list.md), uses Cardano products/protocols (aka services) and holds one or more of its [4,172,655 Native Tokens (as of Nov-2021)](https://pool.pm/tokens)
- Governance Participant: [Governance](https://cardano.org/governance/) Voter/Contributor and earns ADA voting for the future of Cardano
- Protocol Evolution Contributor: Raises proposals and participates in future protocol decision and standards discussions through [CIPs](https://cips.cardano.org/)

### Builder
- Stake Pool Operator (SPO): Manages secure and reliable infrastructure to host a block-producing [cardano-node](https://github.com/input-output-hk/cardano-node/)
- Infrastructure and Integration Developer: Builds Off-chain integration pieces e.g. APIs, SDKs, CLIs, etc.
- DApp Developer: Builds On-chain Smart Contracts and Off-chain integration for a specific product/protocol
- Utility Developer: Builds wallets, block explorers and utility tools
- NFT Content Creator: Creates Digital Media and Tokenises it as a Cardano Native Asset
- Graphics/UX Designer for Cardano products/protocols

📝 *With that in mind, Lovelace Academy as an education platform is mostly geared to the builders of Cardano so most of the subsequent content will be **technical** in nature.*

## A Paradigm Shift for Builders
As Blockchain sits at the intersection of cryptography, computer science, distributed systems and economics beginners might be overwhelmed with the amount of knowledge required to understand each field. However, do not fear! You do not need to be such an advanced polymath to start building something on Cardano. In fact, you can already begin your journey with a basic understanding of software development.

### Key Differences vs Traditional Software Development
As a developer you will be familiar with the client-server paradigm where clients/frontends interact with remote servers managed by a central organisation. These remote servers almost always sit on top of distributed databases and interact with other servers within their closed network. As a result the data, connectivity and interactions become centralised and isolated in large silos across the internet.

Blockchain and Web3 democratises and opens up that paradigm so that all the data is replicated within an open network, where everyone can run the servers themselves in the form of full nodes. Here is a summary of the key differences:

#### Ownership of Data
- Owned by participants of the open blockchain network

#### Infrastructure and Data Integrity
- Everyone connects to a resilient network of full nodes 
- Everyone can run a full node
- Every full node synchronises a full copy of the database with its peers
- Every full node validates the integrity of the data using cryptography

#### Updating Data
- To update any data we must submit a transaction (Tx)
- Every Tx has a fee in ADA based on its payload
- Everyone can submit a Tx as long as the accounting/cryptographic/smart contract validation succeeds
- Every Tx propagates through the network of full nodes after submission in a _pending_ state
- Pending Txs are batched into Blocks committed by Stake Pools at a regular interval
- Everyone can participate in the Proof-of-Stake consensus to commit new Blocks (i.e. be a SPO) and be rewarded for doing so
- Tx finalisations are not immediate. A by-product of eventual consistency in distributed systems with additional protection against invalid forks

#### Computation and Storage
- On-chain computation (i.e. Executing Smart Contracts) has compute/time & storage/space costs 
- On-chain computation can only work with data that exists on-chain (i.e. No integration outside the Blockchain itself apart from Oracle-inserted data)
- On-chain storage of _additional_ data comes at a cost (e.g. metadata)

#### Technical Limitations?
- The benefits of decentralisation and having an open and trusted global network of value **far outweighs** the raw technical limitations (e.g. limited throughput & storage) of the base layer
- Scaling solutions are already on the way
- Blockchains or distributed ledgers are meant to complement, not replace traditional IT infrastructure

## Run Your Own Full Cardano Node
Now that you learnt about full nodes, continue to **[Running a Full Node ➡️](https://learn.lovelace.academy/getting-started/running-a-full-node/)**