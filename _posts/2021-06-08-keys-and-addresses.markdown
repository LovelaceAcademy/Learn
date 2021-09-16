---
layout: post
title: "Wallet Basics: Keys and Addresses"
categories:
- Getting Started
last_modified_at: 2021-06-09
order: 4
---

Keys and addresses are cryptographic entities at the heart of all information flow in Cardano and other blockchains. 
Keys prove ownership, consent and authenticity
while addresses derived from these keys are destinations to hold facts
and values. Subsequently all the facts/values in these addresses 
can only be unlocked for verification/spending using the keys associated with them, safeguarding them from theft or confiscation.

There are [many different types of keys](https://cips.cardano.org/cips/cip5/) that exist in Cardano, but here we will be focusing on the address keys on the right section of the
image below.

![](https://github.com/ilap/ShelleyStuffs/raw/master/images/ShelleyKeyAndAddresses.png)

Image courtesy of [ilap](https://github.com/ilap)

A powerful feature arises from the fact that these cryptographic
entities can be created without connecting to or interacting with the network. The de-coupling of these entities from the network
allows any one, even those without an internet connection, to create
unique addresses that can receive ADA/custom tokens. 

## Keys

Two main types of keys are used within Cardano:

- Payment Keys: For creating payment addresses to receive ADA/custom tokens, and signing transactions
  to spend ADA/custom tokens from these payment addresses
- Stake Keys: For creating payment/staking addresses, delegating
  stake, claiming ADA rewards from stake addresses and registering
  stake pools

Following the principles of [public key/asymmetric cryptography](https://www.blockchain-council.org/blockchain/how-does-blockchain-use-public-key-cryptography/), these are [Ed25519](https://en.wikipedia.org/wiki/EdDSA#Ed25519) pairs
consisting of a private signing key and a public verification key. 

### Creating Payment Keys

```bash
cardano-cli address key-gen --verification-key-file payment.vkey --signing-key-file payment.skey
```

This will create two files, the private signing key `payment.skey` and the
public verification key `payment.vkey` in the current directory.

<blockquote class="media notice notice-danger"><i class="icon_ribbon_alt"></i><div markdown="1">

Outside of the testnets it is **EXTREMELY** important to safeguard
your private signing keys.

Creation of keys should be always be done in a **trusted air-gapped
machine** with a **pristine operating system** (e.g. a fresh Ubuntu
[VirtualBox VM](https://www.virtualbox.org/wiki/Downloads) with no
non-base-OS software apart from a verified version of cardano-cli) and
**no network/internet connectivity**. <!-- Signing transactions should
also be done in the air-gapped machine containing the private keys
where signed transactions can then be transferred out via a secure
USB. At no point should the signing keys be transferred to another
machine that is not air-gapped. -->

These key files can transferred to/from a secure USB (e.g. Apricorn
Aegis) when necessary to ensure a fresh pristine environment every
time. We also recommended writing down the contents of the private
keys on a physical medium to be stored securely in case of
software/hardware failure.

</div></blockquote>

### Creating Stake Keys

```
cardano-cli stake-address key-gen --verification-key-file stake.vkey --signing-key-file stake.skey
```

This will create the private signing key `stake.skey` and the public
verification key `stake.vkey` in the current directory.

## Addresses

The keys above are then used to create two main types of addresses:

- Payment addresses: To receive ADA/custom tokens
- Stake/Reward addresses: To receive ADA staking rewards (automatically)

These are a [blake2b-256](https://en.wikipedia.org/wiki/BLAKE_(hash_function)#BLAKE2)
hash of the public key(s) and concatenated with other metadata (see
different address types in the image above) including the network in
which they are valid for (e.g. --mainnet, --testnet-magic 1097911063,
etc.)

### Creating a Payment Address

Payment addresses are generally created using both payment and staking
verification keys to create an address known as base address. The act of
re-using the same stake key to generate multiple payment addresses
allow all the ADA at these addresses to be automatically staked to the
same designated stake pool. However it is also possible to create
[enterprise
addresses](https://docs.cardano.org/en/latest/learn/types-addresses.html#enterprise-addresses),
the term for a non-staking payment address, by excluding the
`--stake-verification-key-file` parameter below.

```bash
cardano-cli address build \
    --payment-verification-key-file payment.vkey \
    --stake-verification-key-file stake.vkey \
    --testnet-magic 1097911063 \
    --out-file payment.addr
```

### Creating a Stake/Reward Address

A unique stake address is generated from a staking verification key.

```bash
cardano-cli stake-address build \
    --stake-verification-key-file stake.vkey \
    --testnet-magic 1097911063 \
    --out-file stake.addr
```

With your newly created keys and addresses you can create, sign and
submit transactions to learn about [UTxOs and Metadata](https://learn.lovelace.academy/getting-started/transactions-utxo-and-metadata/).

## Supplementary Material
[Cardano Docs: Cardano addresses](https://docs.cardano.org/core-concepts/cardano-addresses)

[Cardano Developers: Creating Keys and Addresses](https://developers.cardano.org/docs/stake-pool-course/handbook/keys-addresses/)

[Learn me a bitcoin: Keys and Addresses](https://learnmeabitcoin.com/beginners/keys_addresses)

