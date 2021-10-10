---
layout: post
title: Introduction to Tokens
last_modified_at: 2021-09-08
categories:
- Native Tokens
order: 1
---

Tokens are representations of assets or facts that can be minted (created/destroyed), stored and transferred within a blockchain. In the context of blockchains the terms *token* and *asset* are interchangeable.

## Multi-asset Blockchains
Unlike single-asset blockchains like Bitcoin or Litecoin which only support a single principal token (i.e. BTC and LTC), a multi-asset blockchain supports minting, storing or transferring custom tokens on top of its principal token. Examples of multi-asset blockchains are Ethereum and Cardano which support an infinite amount of custom tokens in addition to their principal token (i.e. ETH and ADA).

This allowed users to define custom tokens representing:
 - **Fungible Assets**: Units of value grouped under a specific category (e.g. currency, loyalty points, game points), each unit indistinguishable from another under the same group
 - **Non-Fungible Assets (NFTs)**: A single unit representing an asset or fact that is unique across the entire blockchain (e.g. art collectables, identity, real estate)

## Native Tokens / Assets
A multi-asset blockchain has native token/asset support if all its custom tokens follow the same base-layer accounting rules as its principal token. The following advantages arise from native token/asset support:
 - Cheap, fast and reliable transactions for all tokens
 - Universal interoperability of all tokens
 - Simple minting process for custom tokens
 - Ability to bundle minting/transfer of multiple tokens in a single transaction (e.g. Token Bundles)

Examples of blockchains with native token/asset support are Cardano, Ergo and Algorand.

## Cardano's Native Tokens
There are a few key points to note around Cardano's implementation of native tokens.
 - A transaction output containing custom tokens must include a minimum amount of the principal token ADA
 - The minimum amount of the principal token ADA is calculated using a [formula based on protocol parameters and the payload of the transaction output](https://cardano-ledger.readthedocs.io/en/latest/explanations/min-utxo.html#min-ada-value-calculation)

This design decision prevents an attack vector where malicious actors can flood the Cardano network with an endless stream of custom token transaction outputs, resulting in large transaction payloads propagating across the network and an unmanageable set of UTxOs. 

## Supplementary Material
 - [Cardano Docs: Native Tokens](https://docs.cardano.org/native-tokens/learn)
 - [Cardano Developers Portal: Discover Native Tokens](https://docs.cardano.org/native-tokens/learn)

 ## Create Minting Policies
 Continue on to [Minting Policies
 ➡️](https://learn.lovelace.academy/native-tokens/minting-policies/)
