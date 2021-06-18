---
layout: post
title: "Transactions: UTxO and Metadata"
categories:
- Getting Started
---

Transactions are basic units representing the creation or transfer of
values in a blockchain and make up a significant payload of every block
appended to it. Transactions and their metadata last the entire lifetime
of the blockchain, so once appended and accepted by the majority of the
network, cannot be altered or deleted without a major coordinated event
like a hard fork.

## The UTxO Accounting Model

Cardano, like Bitcoin, uses the UTxO accounting model to signify the
flow of values from transactions. UTxO stands for **U** nspent **T**
ransaction **O** utput.

As opposed to an accounts-based blockchain (e.g. Ethereum) which holds
one single value representing the active balance of an address,
addresses in Cardano can hold multiple transaction outputs and it is up
to the wallet software to calculate the active balance from the current
set of UTxOs. Although it may seem like unnecessary complexity, this
model provides a more elegant, performant and deterministic model to
reason with the current state of the blockchain. We will focus on the
simpler Shelley UTxO model and expand on EUTxO (Extended UTxO) and its
main benefits in another article.

The UTxO model can be best visualised as a graph where all inputs to new
transactions must **spend** an unspent output from a previous
transaction in its entirety to produce new outputs, usually resulting in
"change" outputs being sent back to the payer. Much like the law of
conservation of energy, the sum of all inputs must be equal to the sum
of all outputs minus the transaction fee. This means all values can be
traced back to the transaction distributing the initial ADA supply in
the genesis block, minted ADA from transactions claiming stake rewards
or from transactions minting custom tokens.

## The Structure of a Transaction

![](https://github.com/ilap/ShelleyStuffs/raw/master/images/ShelleyTransactionChanges4Gougen.png)

Image courtesy of [ilap](https://github.com/ilap)

## Guide: Creating an Example Transaction

Cardano Wallets hide away much of the subtleties behind transactions so
in this guide we will create, sign and submit a transaction sending 100
ADA to another address using the cardano-cli.

### Load ADA from Testnet Faucet

Use the [testnet
faucet](https://developers.cardano.org/en/testnets/cardano/tools/faucet/)
to send ADA to the payment address generated in our article [Wallet
Basics: Keys and
Addresses](https://learn.lovelace.academy/getting-started/keys-and-addresses/). You
can see the payment address with:

```bash
cat payment.addr
```

### Query Unspent Transaction Outputs for Address

After a short while (minute or less) you can verify the funds from the
faucet have arrived in your payment.addr by running the following:

```bash
UTXO0=$(cardano-cli query utxo --address $(cat payment.addr) --testnet-magic 1097911063 | sed -n 3p) 
UTXO0H=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 1p)
UTXO0I=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 2p)
UTXO0V=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 3p)
echo $UTXO0
```


### Create Destination Payment Address

Create a new set of keys and a destination payment address
destination\_payment.addr.

```bash
cardano-cli address key-gen --verification-key-file destination_payment.vkey --signing-key-file destination_payment.skey
cardano-cli address build --payment-verification-key-file payment.vkey --testnet-magic 1097911063 --out-file destination_payment.addr
```

### Load Protocol Parameters File

Transactions must always refer to the latest version of the Cardano
protocol parameters which can be retrieved by running:

```bash
cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json 
```


### Draft Transaction to Calculate Fees

Calculating fees for a transaction requires you to first create a draft
transaction following a similar structure to the real transaction. Note
that --tx-in uses the UTxO details queried above (transaction ID UTXO0H
and transaction output index UTXO0I). Also note --tx-out parameters
sending 100 ADA (100000000 lovelaces) to the destination address and 900
ADA (900000000 lovelaces) back to the payment address as change.

```bash
rm draft.txraw 2> /dev/null
cardano-cli transaction build-raw --tx-in $(echo $UTXO0H)#$(echo $UTXO0I) --tx-out $(cat destination_payment.addr)+100000000 --tx-out $(cat payment.addr)+900000000 --ttl 0 --fee 0 --out-file draft.txraw
FEE=$(cardano-cli transaction calculate-min-fee \
    --tx-body-file draft.txraw \
    --tx-in-count 1 \
    --tx-out-count 2 \
    --witness-count 1 \
    --testnet-magic 1097911063 \
    --protocol-params-file protocol.json | egrep -o '[0-9]+')
```

### Raw Transaction with Metadata

With the fee we can now calculate the correct amount of change ADA to be
sent back to the payment address. We also define a --ttl parameter to
define how long this transaction is valid for (denoted by the current
slot tip of the chain + 600 seconds) before it is rejected by the
network.

```bash
CTIP=$(cardano-cli query tip --testnet-magic 1097911063 | jq -r .slot)
TTL=$(expr $CTIP + 600)
TXOUT=$(expr $UTXO0V - $FEE - 100000000) 
cardano-cli transaction build-raw \
  --tx-in $(echo $UTXO0H)#$(echo $UTXO0I) --tx-out $(cat destination_payment.addr)+100000000 --tx-out $(cat destination_payment.addr)+$(echo $TXOUT) --ttl $TTL --fee $FEE --out-file sendtx.txraw
```

### Signing a Transaction

With the previously generated payment private signing key payment.skey
we can sign the transaction to prove consent to spend the ADA as the
holder of the keys to the payment address. Note that this has to be done
offline in an air-gapped machine outside of the testnets.

```bash
cardano-cli transaction sign \
    --tx-body-file sendtx.txraw \
    --signing-key-file payment.skey \
    --testnet-magic 1097911063 \
    --out-file sendtx.txsigned
```


### Submitting a Transaction

With the signed transaction we can now submit it to the rest of the
blockchain network. Once successfully submitted it will propagate across
all the nodes in the network residing in their mem pools until bundled
onto the next available block by a stake pool node.

```bash
cardano-cli transaction submit \
    --tx-file sendtx.txsigned \
    --testnet-magic 1097911063 
```

## Exploring Transactions

Using an explorer is the easiest way to navigate across all the addresses, blocks and transactions in Cardano.

- [Cardano Blockchain Explorer](https://explorer.cardano.org/)
- [Cardano Scan](https://cardanoscan.io/)
- [ADA Stat](https://adastat.net/)
- [ADAex.org](https://adaex.org/)
- [Blockchair: Cardano](https://blockchair.com/cardano)
- [Pool.pm (toggle TXs)](https://pool.pm/)
