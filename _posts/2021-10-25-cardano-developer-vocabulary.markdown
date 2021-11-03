---
layout: post
title: Cardano Developer Vocabulary
last_modified_at: 2021-06-07
categories:
- Getting Started
order: 6
---

Even seasoned developers can find the plethora of new terms associated with Blockchain development intimidating and at times plain confusing or cryptic. To address these pain points we have created the **Cardano Developer Vocabulary**, a concise glossary to explain the most important yet commonly mistaken terms grouped by major concepts.

## Time
Moments in time across Cardano are generally specified using incrementing integers. For example to-the-second precise units called `Slots` and five-day windows known as `Epochs`. Last but not least these moments reside within `Eras`, which are simply text labels for significant Cardano network milestones. For example, {% include tooltips/basic.html tooltip="9:00AM UTC on November 3rd" content="2021-11-03T09:00:00Z in ISO 8601 format" %} is Slot 44363709, Epoch 300 of the Alonzo Era. 
### Slot
At the current configuration a slot is a unit of time increasing at a rate of one every second. Slots are used to define precise moments in time such as those used in time-locked multisig policies, an expiration for transactions, the current tip of the chain or points in time when a stake pool should produce blocks. 
### Epoch
An epoch is currently configured as a five-day window (i.e. 432,000 slots) and key activities occur at the start of every new epoch. For example the snapshot of all the ADA staked across the network is captured to determine the future block schedule, rewards are distributed to stake addresses for previous epochs, and protocol parameter updates are promoted. Some epoch transitions can even herald major network upgrade events (HFCs) through era transitions.

## Data Formats
Cardano uses data serialisation and encoding formats that aren't typically used across the software industry (e.g. JSON, ProtoBuf, CSV, etc.) but are chosen due to their compact size, computational efficiency and ease of use with cryptographic functions.
### CBOR
**C** oncise **B** inary **O** bject **R** epresentation is a binary serialisation format (similar to BSON, ProtoBuf, FlatBuffers) that plays nice with cryptographic signing and encryption. It is used to serialise most of the data between Cardano components.
### CDDL
**C** oncise **D** ata **D** efinition **L** anguage defines a human-readable schema for CBOR types. This is similar to JSON Schema or ProtoBuf structures in a `.proto` file and can also be used to define cross-boundary API contracts.
### BECH32
BECH32 (not to be confused with BIP32 in the standards section below) is a human-readable encoding format with [standardised prefixes](https://cips.cardano.org/cips/cip5/) such as addr1 or asset1. It is used across Cardano for end-user facing objects such as keys, addresses and native assets. 

## Improvement Proposals 
The Blockchain industry is built on top of innovative standards (BIP/EIP/CIP/etc.) that arose out of documented improvement proposals from different ecosystems. 
### BIP and EIP
Standards that came from [**B**itcoin **I**mprovement **P**roposals](https://github.com/bitcoin/bips) or [**E**thereum **I**mprovement **P**roposals](https://github.com/ethereum/EIPs/tree/master/EIPS). Notable ones include BIP32, BIP39 and BIP44 that laid the foundation for cross-chain wallets through recovery phrases, root keys and hierarchical structured child keys/addresses. It is also worthwhile knowing EIPs such as EIP20 and EIP721 which define the ERC20 and ERC721 token standards for tokens and non-fungible tokens in Ethereum.
### CIP
Standards that came from Cardano. See the [full list](https://github.com/cardano-foundation/CIPs). 

## Cryptography
As with most Blockchains, two main cryptographic primitives are used, **hash functions** and **public key or asymmetric cryptography**. Specific algorithms are used below.
### Blake2b
Cardano uses the [Blake2b](https://datatracker.ietf.org/doc/html/rfc7693) as a fast hashing algorithm to generate hash digests of commonly used objects in Cardano.
### Ed25519
[Ed25519](https://datatracker.ietf.org/doc/html/rfc8032) is used throughout Cardano for speedy digital signatures based on private signing and public verification key pairs.

🚧 _More content coming soon_

## Learn about Cardano's Native Tokens
Now you can learn how to mint tokens on Cardano. Continue to [Introduction to Tokens
 ➡️](https://learn.lovelace.academy/tokens/introduction-to-tokens/)

