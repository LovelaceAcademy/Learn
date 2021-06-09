---
layout: post
title: "Wallet Basics: Keys and Addresses"
categories:
- Getting started
last_modified_at: 2021-06-09
---

Keys and addresses are at the heart of all information flow in Cardano
and other blockchains. Keys represent ownership, consent and
authenticity while addresses derived from these keys hold facts and
values.

A powerful feature arises from the fact that these cryptographic
entities can be created without connecting to or interacting with the
blockchain network. The de-coupling of these entities from the network
allows any one, even those without an internet connection, to create
unique addresses that can receive transaction outputs. Subsequently all
the facts and values in these addresses can only be unlocked by the keys
associated with it, safeguarding them from confiscation.

We will be focusing on the address keys on the right.

![](https://github.com/ilap/ShelleyStuffs/raw/master/images/ShelleyKeyAndAddresses.png)

Image courtesy of [Pal](https://github.com/ilap)

## Keys

Two main types of keys are used within Cardano:

- Payment Keys: For signing transactions to spend ADA/assets in payment
  addresses

- Staking Keys: For delegating stake, claiming ADA rewards from rewards
  addresses and registering stake pools

Both types are [Ed25519](https://en.wikipedia.org/wiki/EdDSA#Ed25519)
key pairs consisting of a private signing key and a public verification
key.

> Outside of the testnets it is **EXTREMELY** important to safeguard
> your private signing keys.
> 
> Creation of keys should be always be done in a **trusted air-gapped
> machine** with a **pristine operating system** (e.g. a fresh Ubuntu
> VirtualBox VM with no additional software apart from a verified
> version of cardano-cli) and **no network/internet connectivity**. <!--
> Signing transactions should also be done in the air-gapped machine
> containing the private keys where signed transactions can then be
> transferred out via a secure USB. At no point should the signing keys
> be transferred to another machine that is not air-gapped. -->
> 
> These key files can transferred to/from a secure USB (e.g. Apricorn
> Aegis) when necessary to ensure a fresh pristine environment every
> time. It is also recommended to write down the contents of the private
> keys on a physical medium which is stored securely in case of
> software/hardware failure.

### Creating Payment Keys

```bash
cardano-cli address key-gen --verification-key-file payment.vkey --signing-key-file payment.skey
```

This will create two files, the private signing key payment.skey and the
public verification key payment.vkey in the current directory.

### Creating Staking Keys

```bash
cardano-cli stake-address key-gen --verification-key-file stake.vkey --signing-key-file stake.skey
```

This will create the private signing key stake.skey and the public
verification key stake.vkey in the current directory.

## Addresses

The keys above are then used to create two main types of addresses:

- Payment addresses: To receive ADA/assets
- Staking addresses: To receive ADA staking rewards (automatically)

The generated addresses are encoded with the network in which they are
valid for (e.g. --mainnet or --testnet-magic 1097911063) concatenated
with other metadata (see different address types in the image above) and
hashed using
[blake2b-256](https://en.wikipedia.org/wiki/BLAKE_(hash_function)#BLAKE2)
to ensure a unique address of a consistent length. 

### Creating a Payment Address

Payment addresses are generally created using both payment and staking
verification keys. Re-using the same staking key to generate multiple
payment addresses allow all the ADA from these addresses to be
automatically staked to a designated stake pool. However it is also
possible to create [enterprise
addresses](https://docs.cardano.org/en/latest/learn/types-addresses.html#enterprise-addresses),
a formal term for a non-staking payment address by excluding the
--stake-verification-key-file parameter below.

```bash
cardano-cli address build \
--payment-verification-key-file payment.vkey \
--stake-verification-key-file stake.vkey \
--testnet-magic 1097911063 \
--out-file payment.addr
```

### Creating a Staking Address

A unique staking address is generated from a staking verification key.

```bash
cardano-cli stake-address build \
  --stake-verification-key-file stake.vkey \
  --testnet-magic 1097911063 \
  --out-file stake.addr
```

With your newly created keys and addresses you can create transactions
to learn about UTxOs and Metadata.
