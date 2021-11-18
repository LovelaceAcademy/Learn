---
layout: post
title: "Transactions: UTxO and Metadata"
last_modified_at: 2021-11-16
categories:
- Getting Started
order: 5
---

Transactions are the single most important unit in blockchains. They signify the creation or transfer of all values within it, contains verifiable cryptographic proof of their validity, and make up a significant payload of every block appended to it. Transactions and their metadata are **immutable and 
last the lifetime of the blockchain**, so once appended and accepted by 
the majority of the network, cannot be altered or deleted without a 
major coordinated event like a hard fork.

### Goals
This guide will help you understand the UTxO accounting model. You will then build, sign and submit your first transaction with metadata using the `cardano-cli`.

### Prerequisites 
From our previous post **[Running a Full Cardano Node](https://learn.lovelace.academy/getting-started/running-a-full-node/)**
 - The `cardano-cli` binary 
 - The `cardano-node` binary that is actively running and fully synchronised

From our previous post **[Wallet Basics: Keys and Addresses
](https://learn.lovelace.academy/getting-started/keys-and-addresses/)**
 - Payment address key pair files `payment.skey` and `payment.vkey`
 - Payment base address file `payment.addr`

## Background 

### The UTxO Accounting Model

Cardano, like Bitcoin and Ergo, uses the UTxO accounting model to signify the flow of values from transactions. UTxO stands for **U** nspent **Tx** ransaction **O** utput. A transaction at its core is a set of inputs and outputs, where inputs are consumed/spent to produce new outputs.

As opposed to an accounts-based blockchain (e.g. Ethereum) which holds
one single value representing the active balance of an address,
addresses in Cardano can hold **multiple** transaction outputs, and it is up to the wallet to calculate the active balance by summing the
current set of UTxOs. This parallels with cash-based accounting where notes are used in transactions (i.e. pay and get change) and the 
holder's active balance is the sum of all the notes in their wallet.

Although it may seem like unnecessary complexity, this
model provides a more **elegant**, **performant** and **deterministic** model to
reason with the current state of the blockchain and prevent double-spending. 
We will focus on the simpler Shelley UTxO model and _expand_ on EUTxO 
(Extended UTxO) and its main benefits in [another article](https://learn.lovelace.academy/fundamentals/eutxo/).

![](/img/utxo-visual.png)

The UTxO model can be best visualised as an **input-output graph** where inputs to
transactions (the blue squares) **fully consume** outputs from previous transactions, with the values sent to one or more addresses as new outputs. 
Once the outputs are spent (the red circles), they can no longer 
be used by future transactions as inputs, and new transactions can only 
use active UTxOs (the green circles) as inputs. It is with the set of 
active UTxOs that the global active state of the blockchain is derived.

Much like the law of conservation of energy, the **sum of all inputs must be equal 
to the sum of all outputs minus the transaction fees**. For typical payment
transactions this usually results in "change" outputs being sent back to the payer.
This elegant model also means all active ADA and custom tokens on Cardano's ledger can be
traced back to a transaction distributing the initial ADA supply in
the genesis block, minted ADA from transactions claiming stake rewards
or from transactions minting custom tokens. 

## The Structure of a Transaction

![](https://github.com/ilap/ShelleyStuffs/raw/master/images/ShelleyTransactionChanges4Gougen.png)

Image courtesy of [ilap](https://github.com/ilap)

## Guide to Submitting a Tx sending ADA

Cardano Wallets hide away much of the subtleties behind transactions so
in this guide we will create, sign and submit a transaction sending 100
ADA to another address using the cardano-cli.

### Load ADA from Testnet Faucet

Use the [testnet
faucet](https://testnets.cardano.org/en/testnets/cardano/tools/faucet/)
to send ADA to the payment address generated in our article [Wallet
Basics: Keys and
Addresses](https://learn.lovelace.academy/getting-started/keys-and-addresses/). You
can see your payment address by running:

```bash
cat payment.addr
```

### Query Unspent Transaction Outputs for Address

After a short while (minute or less) you can verify the funds from the
faucet have arrived in your payment.addr by running the following:

{% tabs queryutxo %}
{% tab queryutxo#Testnet %}
```bash
UTXO0=$(cardano-cli query utxo --address $(cat payment.addr) --testnet-magic 1097911063 | sed -n 3p) 
UTXO0H=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 1p)
UTXO0I=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 2p)
UTXO0V=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 3p)
echo $UTXO0
```
{% endtab %}
{% tab queryutxo#Mainnet %}
```bash
UTXO0=$(cardano-cli query utxo --address $(cat payment.addr) --mainnet | sed -n 3p) 
UTXO0H=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 1p)
UTXO0I=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 2p)
UTXO0V=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 3p)
echo $UTXO0
```
{% endtab %}
{% endtabs %}

**Note**: It will store the details for the UTxO of that transaction in the shell variables
**`UTXO0H`(transaction ID)**, **`UTXO0I`(transaction output index)** and **`UTXO0V`(transaction output value)**. These variables will be used later when we are building the raw transaction within the `--tx-in` input parameter.

### Create Destination Payment Address

Create a new set of address keys and a payment address for the destination of this transaction `destination_payment.addr`.

{% tabs addrgen %}
{% tab addrgen#Testnet %}
```bash
cardano-cli address key-gen --verification-key-file destination_payment.vkey --signing-key-file destination_payment.skey

cardano-cli address build --payment-verification-key-file destination_payment.vkey --testnet-magic 1097911063 --out-file destination_payment.addr
```
{% endtab %}
{% tab addrgen#Mainnet %}
```bash
cardano-cli address key-gen --verification-key-file destination_payment.vkey --signing-key-file destination_payment.skey

cardano-cli address build --payment-verification-key-file destination_payment.vkey --mainnet --out-file destination_payment.addr
```
{% endtab %}
{% endtabs %}
📝 _Built without any stake keys, `destination_payment.addr` is a basic enterprise addresses with no staking rights_
 
### Create Metadata JSON File (Optional)

We can attach up to 16kB of structured metadata to our transaction which will be
stored and immutable for as long as the blockchain exists. The easiest 
approach is to create a JSON file and specify it when building the transaction. 

```bash
cat > metadata.json << EOF 
{
  "14141342": {
      "ex": "Lovelace Academy|Getting Started|Transactions: UTxO and Metadata",
      "v" : "6",
      "ts": "2021-10-08T16:10:34Z"
  },
  "14145256": {
      "h": "D9FCBD0EF020D1E3E3032A481814A4B8491D06323933EA708C2C62F90FF83567"
  }
}
EOF
```

The top level keys of the JSON object must be string representations of a
64bit integer and it is recommended to check against existing values in the 
[official metadata registry](https://github.com/cardano-foundation/CIPs/blob/master/CIP-0010/registry.json) 
to avoid conflicts. 

Although negligible for small JSON files as our example above, 
storing metadata will incur an additional fee based on its size. 
You can verify the difference in fees by excluding the `--metadata-json-file`
parameter when building the raw transactions below. 

For more information please refer to the 
[Transaction Metadata](https://github.com/input-output-hk/cardano-node/blob/master/doc/reference/tx-metadata.md#transaction-metadata) 
documentation.

### Draft Transaction to Calculate Fees

Calculating transaction fees must always refer to the latest version of the Cardano protocol parameters which can be retrieved by running:

{% tabs protocolparams %}
{% tab protocolparams#Testnet %}
```bash
cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json 
```
{% endtab %}
{% tab protocolparams#Mainnet %}
```bash
cardano-cli query protocol-parameters --mainnet --out-file protocol.json 
```
{% endtab %}
{% endtabs %}

Calculating fees for a transaction requires you to first create a draft
transaction following a similar structure to the real transaction. Note
that `--tx-in` uses the shell variables from the payment.addr UTxO query three steps above, follows the format `{utxo_tx_hash}#{utxo_tx_output_index}` and _can_ have multiple entries. 
Also note `--tx-out` parameters sending 100 ADA (100000000 lovelaces) 
to the destination address and 900ADA (900000000 lovelaces) back to the payment address as change. Each `--tx-out` follows the format `{output_address}+{lovelace_value}`.

{% tabs drafttx %}
{% tab drafttx#Testnet %}
```bash
rm draft.txraw 2> /dev/null
cardano-cli transaction build-raw \
    --tx-in $UTXO0H#$UTXO0I \
    --tx-out $(cat destination_payment.addr)+100000000 \
    --tx-out $(cat payment.addr)+900000000 \
    --metadata-json-file metadata.json \
    --invalid-hereafter 0 \
    --fee 0 \
    --out-file draft.txraw
FEE=$(cardano-cli transaction calculate-min-fee \
    --tx-body-file draft.txraw \
    --tx-in-count 2 \
    --tx-out-count 1 \
    --witness-count 1 \
    --testnet-magic 1097911063 \
    --protocol-params-file protocol.json | egrep -o '[0-9]+')
echo Fee: $FEE
```
{% endtab %}
{% tab drafttx#Mainnet %}
```bash
rm draft.txraw 2> /dev/null
cardano-cli transaction build-raw \
    --tx-in $UTXO0H#$UTXO0I \
    --tx-out $(cat destination_payment.addr)+100000000 \
    --tx-out $(cat payment.addr)+900000000 \
    --metadata-json-file metadata.json \
    --invalid-hereafter 0 \
    --fee 0 \
    --out-file draft.txraw
FEE=$(cardano-cli transaction calculate-min-fee \
    --tx-body-file draft.txraw \
    --tx-in-count 2 \
    --tx-out-count 1 \
    --witness-count 1 \
    --mainnet \
    --protocol-params-file protocol.json | egrep -o '[0-9]+')
echo Fee: $FEE
```
{% endtab %}
{% endtabs %}

### Raw Transaction with Metadata

With the fee we can now calculate the correct amount of change ADA to be
sent back to the payment address. We can also define a `--invalid-hereafter` parameter to
define how long this transaction is valid for (denoted by the current
slot tip of the chain + 600 seconds) before it is rejected by the
network.

{% tabs realtx %}
{% tab realtx#Testnet %}
```bash
CTIP=$(cardano-cli query tip --testnet-magic 1097911063 | jq -r .slot)
TTL=$(expr $CTIP + 600) # 10 minutes 
CHANGE=$(expr $UTXO0V - 100000000 - $FEE) 
cardano-cli transaction build-raw \
  --tx-in $UTXO0H#$UTXO0I \
  --tx-out $(cat destination_payment.addr)+100000000 \
  --tx-out $(cat payment.addr)+$(echo $CHANGE) \
  --metadata-json-file metadata.json \
  --invalid-hereafter $TTL \
  --fee $FEE \
  --out-file sendtx.txraw
```
{% endtab %}
{% tab realtx#Mainnet %}
```bash
CTIP=$(cardano-cli query tip --mainnet | jq -r .slot)
TTL=$(expr $CTIP + 600) # 10 minutes 
CHANGE=$(expr $UTXO0V - 100000000 - $FEE) 
cardano-cli transaction build-raw \
  --tx-in $UTXO0H#$UTXO0I \
  --tx-out $(cat destination_payment.addr)+100000000 \
  --tx-out $(cat payment.addr)+$(echo $CHANGE) \
  --metadata-json-file metadata.json \
  --invalid-hereafter $TTL \
  --fee $FEE \
  --out-file sendtx.txraw
```
{% endtab %}
{% endtabs %}

### View Transaction 
You can view the friendly output of your transaction by running
```bash
cardano-cli transaction view --tx-body-file sendtx.txraw
```
📝 _Note all the other fields in the transaction and refer back to the [Structure of a Transaction Image](#the-structure-of-a-transaction)_

### Signing a Transaction

With the previously generated payment private signing key `payment.skey`
we can sign the transaction to prove consent to spend the ADA as the
holder of the keys to the payment address. Note that this has to be done
offline in an air-gapped machine outside of the testnets.

{% tabs signtx %}
{% tab signtx#Testnet %}
```bash
cardano-cli transaction sign \
    --tx-body-file sendtx.txraw \
    --signing-key-file payment.skey \
    --testnet-magic 1097911063 \
    --out-file sendtx.txsigned
```
{% endtab %}
{% tab signtx#Mainnet %}
```bash
cardano-cli transaction sign \
    --tx-body-file sendtx.txraw \
    --signing-key-file payment.skey \
    --mainnet \
    --out-file sendtx.txsigned
```
{% endtab %}
{% endtabs %}

### Get Transaction ID
You can also get the transaction ID (aka Tx Hash) of your transaction before it is submitted by running the following commands.
```bash
cardano-cli transaction txid --tx-file sendtx.txsigned

# Alternatively for the unsigned txraw file
cardano-cli transaction txid --tx-body-file sendtx.txraw
```

### Submitting a Transaction

With the signed transaction we can now submit it to the rest of the
blockchain network. Once successfully submitted it will propagate across
all the nodes in the network residing in their mem pools until bundled
onto the next available block by a stake pool node.

{% tabs submittx %}
{% tab submittx#Testnet %}
```bash
cardano-cli transaction submit \
    --tx-file sendtx.txsigned \
    --testnet-magic 1097911063 
```
{% endtab %}
{% tab submittx#Mainnet %}
```bash
cardano-cli transaction submit \
    --tx-file sendtx.txsigned \
    --mainnet 
```
{% endtab %}
{% endtabs %}

### Verify the Transaction Result

You can query the payment addresses to verify that the 100 ADA has indeed
been sent successfully. This might take some time in the testnet for the submitted
transaction to be bundled to a block by an active stake pool.

{% tabs verifytx %}
{% tab verifytx#Testnet %}
```bash
# The source payment address with 899 ADA
cardano-cli query utxo --address $(cat payment.addr) --testnet-magic 1097911063

# The destination payment address with 100 ADA
cardano-cli query utxo --address $(cat destination_payment.addr) --testnet-magic 1097911063
```
{% endtab %}
{% tab verifytx#Mainnet %}
```bash
# The source payment address with 899 ADA
cardano-cli query utxo --address $(cat payment.addr) --mainnet

# The destination payment address with 100 ADA
cardano-cli query utxo --address $(cat destination_payment.addr) --mainnet
```
{% endtab %}
{% endtabs %}

Congratulations! You have submitted and verified your first transaction using `cardano-cli`! 

Alternatively you can verify the result in a testnet block explorer like [Cardanoscan](https://testnet.cardanoscan.io/) or [ADATools](https://testnet.adatools.io/transactions) through a direct search of the `transaction ID` from the `Get Transaction ID` step above. Note for mainnet explorer URLs remove the `testnet` subdomain prefix in the URL.

## Using Block Explorers

As shown above, using a block explorer is the easiest way to navigate across all the addresses, blocks and transactions in Cardano.

- [Cardano Scan](https://testnet.cardanoscan.io/)
- [ADATools - Testnet](https://testnet.adatools.io/transactions)
- [ADA Stat](https://adastat.net/)
- [ADAex.org](https://adaex.org/)
- [Blockchair: Cardano](https://blockchair.com/cardano)
- [Pool.pm (toggle TXs)](https://pool.pm/)
- [Cardano Blockchain Explorer](https://explorer.cardano.org/)

## The Cardano Developer Vocaulary
Before diving deeper into development, it is important to understand some key terms and concepts of the **[Cardano Developer Vocabulary
 ➡️](https://learn.lovelace.academy/getting-started/cardano-developer-vocabulary/)**
