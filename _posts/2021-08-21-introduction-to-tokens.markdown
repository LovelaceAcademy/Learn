---
layout: post
title: Introduction to Tokens
last_modified_at: 2021-09-08
categories:
- Tokens
order: 1
---

Tokens are on-chain representations of assets or facts that can be minted (created/destroyed), stored and transferred within a blockchain. In the context of Cardano the terms *token* and *asset* are _generally_ interchangeable, although an asset can be used to denote the class/category of a token before any are minted. 

## Multi-asset Blockchains
Unlike single-asset blockchains (e.g. Bitcoin and Litecoin) which only support a single principal asset (i.e. BTC and LTC), a multi-asset blockchain supports the minting, storing and transferring of custom tokens in addition to its principal asset. Examples of multi-asset blockchains are Ethereum and Cardano, which support an infinite amount of custom tokens in addition to their principal asset (i.e. ETH and ADA). This permits anyone to define custom tokens representing:
 - **Fungible Assets**: Supports multiple units of value grouped under a specific class (e.g. currency, loyalty points, game points), each unit indistinguishable from another under the same class
 - **Non-Fungible Assets (NFTs)**: A single unit representing a distinct asset or fact that is unique across the entire blockchain (e.g. art collectables, identity, real estate)

## Native Assets
A multi-asset blockchain has native asset support (e.g. Cardano, Ergo and Algorand) if all of its custom tokens follow the same base-layer accounting rules as its principal asset. This allows users to mint or transact in custom tokens without paying additional fees incurred by executing token-specific smart contracts. The following advantages arise from native asset support:
 - Cheap, fast and reliable transactions for all tokens
 - Universal interoperability of all tokens
 - Simple minting process for custom tokens
 - Ability to bundle minting/transfer of multiple tokens in a single transaction (e.g. Token Bundles)
 
## Cardano's Native Assets
Although Cardano's implementation of Native Assets resolves many of the current issues plaguing layer-2 token implementations, there are a few key points to note:
 - A Tx output with custom tokens must also include a minimum amount of the principal token ADA
 - The minimum amount of the principal token ADA is calculated using a [formula based on protocol parameters and the payload of the transaction output](https://cardano-ledger.readthedocs.io/en/latest/explanations/min-utxo.html#min-ada-value-calculation)

This design decision prevents an attack vector where malicious actors can easily flood the Cardano network with an endless stream of custom token Tx outputs, resulting in large transaction payloads propagating across the network and an unmanageable set of UTxOs. 

## Supplementary Material
 - [Cardano Docs: Native Tokens](https://docs.cardano.org/native-tokens/learn)
 - [Cardano Developers Portal: Discover Native Tokens](https://docs.cardano.org/native-tokens/learn)

## Create Minting Policies
Continue on to [Minting Policies ➡️](https://learn.lovelace.academy/native-tokens/minting-policies/)
