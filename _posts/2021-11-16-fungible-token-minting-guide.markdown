---
layout: post
title: Fungible Token Minting Guide
last_modified_at: 2021-11-16
categories:
- Tokens
order: 3
---
We will break down how to mint fungible tokens in three basic steps:

1. Create Token Minting Policy
2. Create Wallet Keys and Addresses
3. Build and Submit Minting Tx with Metadata

### Goals
After following this guide you will learn how to make your own token minting policy and mint two different types of fungible tokens under that policy.

### Prerequisites 
From our previous post **[Running a Full Cardano Node](https://learn.lovelace.academy/getting-started/running-a-full-node/)**
 - The `cardano-cli` binary 
 - The `cardano-node` binary that is actively running and fully synchronised

## Create Token Minting Policy

### Create Policy Key
A policy key can be generated using the same approach as generating a payment address key as described in our page [Getting Started - Wallet Basics: Keys and Addresses](https://learn.lovelace.academy/getting-started/keys-and-addresses/).
```bash
cardano-cli address key-gen \
    --verification-key-file ft-policy.vkey \
    --signing-key-file ft-policy.skey
```
Capture the hash of the key in the shell variable `POLICYKEYHASH` by running
```bash
POLICYKEYHASH=$(cardano-cli address key-hash --payment-verification-key-file ft-policy.vkey)
```

### Define Multisig Policy
Create a ft-policy.script file with the right script using
```bash
touch ft-policy.script 
echo "{" >> ft-policy.script 
echo "  \"keyHash\": \"$POLICYKEYHASH\"," >> ft-policy.script
echo "  \"type\": \"sig\"" >> ft-policy.script
echo "}" >> ft-policy.script
```
📝 _Note it is also possible to add a time-lock rule in this policy so no new tokens can be minted after a timestamp. [See our NFT example](https://learn.lovelace.academy/tokens/nft-minting-guide/#create-token-minting-policy) for how to do so_
<details>
    <summary>📄 ft-policy.script (example)</summary>
<pre>
{
  "keyHash": "6d788af8d970a78d2ef3ec43e6515749a607d9c09d8c7441e8d694a9",
  "type": "sig"
}
</pre>
</details>

This policy is a simple policy that requires a single signature from the `ft-policy.skey` private signing key. You can then capture the policyId of the multisig policy in the shell variable `POLICYID` by running:

```bash
POLICYID=$(cardano-cli transaction policyid --script-file ft-policy.script)
```

## Create Wallet Keys and Addresses
We will then create another set of keys for two wallets. One source wallet to get testnet tADA from the faucet to cover the Tx fee, and one destination wallet to receive the minted tokens. Although in theory you can use the same policy key to generate an address to receive tADA and mint the custom tokens, we recommend using different sets of keys based on their purpose. 

📝❗ _In case of mainnet we will know the destination address upfront, so only one set of keys are needed. However as mentioned [earlier](https://learn.lovelace.academy/getting-started/keys-and-addresses/#address-keys), mainnet payment keys should be generated in a trusted air-gapped machine without any network connectivity_

```bash
cardano-cli address key-gen \
    --verification-key-file source.vkey \
    --signing-key-file source.skey

cardano-cli address build \
    --payment-verification-key-file source.vkey \
    --out-file source.addr \
    --testnet-magic 1097911063

cardano-cli address key-gen \
    --verification-key-file dest.vkey \
    --signing-key-file dest.skey

cardano-cli address build \
    --payment-verification-key-file dest.vkey \
    --out-file dest.addr \
    --testnet-magic 1097911063

SOURCEADDR=$(< source.addr)
DESTADDR=$(< dest.addr)
```
📝 _Note the final two lines where the addresses are captured in shell variables `SOURCEADDR` and `DESTADDR`_

### Load ADA from Testnet Faucet
Use the [testnet faucet](https://testnets.cardano.org/en/testnets/cardano/tools/faucet/) to send ADA to the generated source wallet address `$SOURCEADDR`. 

You can then wait a short while and query that the tADA has reached your address by running:
```bash
cardano-cli query utxo \
    --address $SOURCEADDR \
    --testnet-magic 1097911063   
```

## Minting Transaction
By querying the source address that received the 1000 tADA from the faucet, load the relevant UTxO details (hash, index and value) into shell variables.
```bash
UTXO0=$(cardano-cli query utxo --address $SOURCEADDR --testnet-magic 1097911063 | sed -n 3p)
UTXO0H=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 1p)
UTXO0I=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 2p)
UTXO0V=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 3p)    
```

### Build Token Metadata

As we are minting two custom tokens under the same `PolicyID` but with a different `asset_name`s. We initialise the shell variables to specify 1000 `LEARN` tokens and 1 `LA25` token and derive the hexadecimal encoded `asset_name`s.
```bash
LEARN_ASSETNAME=LEARN
LEARN_ASSETHEX=$(echo -n "$LEARN_ASSETNAME" | xxd -b -ps -c 80 | tr -d '\n')
LEARN_QTY=1000
DISCOUNT25_ASSETNAME=LA25
DISCOUNT25_ASSETHEX=$(echo -n "$DISCOUNT25_ASSETNAME" | xxd -b -ps -c 80 | tr -d '\n')
DISCOUNT25_QTY=1
```
Cardano has an [On-Chain Token Metadata Standard](https://github.com/cardano-foundation/CIPs/blob/1d9fbd0e29f07b931bf1524c7aed6635d478cd75/CIP-0035/CIP-0035.md) which we will use to define the correct metadata for our tokens so that wallets, explorers and other tools can interpret and display it correctly. We will create a `token-metadata.json` file with the following content and replace `$POLICYID` with the correct policyID from the first step while using the same fixed IPFS asset URL for logo and icon fields.

```
{
    "20": {
        "$POLICYID": {
            "4c4541524e": {
                "ticker": "LEARN",
                "desc": "Gather LEARN points by completing courses",
                "logo": "ipfs://QmV896wmZc6Rp4pqCex5NN2nYUEjh2zFfGkNfC1qe5Dz4i",
                "icon": "ipfs://QmV896wmZc6Rp4pqCex5NN2nYUEjh2zFfGkNfC1qe5Dz4i"
            },
            "4c413235": {
                "ticker": "LA25",
                "desc": "Lovelace Academy 25% student discount code",
                "logo": "ipfs://QmV896wmZc6Rp4pqCex5NN2nYUEjh2zFfGkNfC1qe5Dz4i",
                "icon": "ipfs://QmV896wmZc6Rp4pqCex5NN2nYUEjh2zFfGkNfC1qe5Dz4i"
            }
        }
    }
}
```

### Get the Latest Protocol Parameters
The current set of Cardano protocol parameters are required to calculate Tx fees and we can retrieve them into the file `protocol.json` with the following command.

```bash
cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json 
```

### Build draft Tx to Calculate Fee
```bash
MIN_LOVELACE=1880000
TXOUT_CHANGE=$(expr $UTXO0V - $MIN_LOVELACE)

cardano-cli transaction build-raw \
    --tx-in $UTXO0H#$UTXO0I \
    --tx-out $DESTADDR+$MIN_LOVELACE+"$LEARN_QTY $POLICYID.$LEARN_ASSETHEX +$DISCOUNT25_QTY $POLICYID.$DISCOUNT25_ASSETHEX" \
    --tx-out $SOURCEADDR+$TXOUT_CHANGE \
    --metadata-json-file token-metadata.json \
    --mint "$LEARN_QTY $POLICYID.$LEARN_ASSETHEX + $DISCOUNT25_QTY $POLICYID.$DISCOUNT25_ASSETHEX" \
    --minting-script-file ft-policy.script \
    --fee 0 \
    --out-file fee_draft.txraw

FEE=$(cardano-cli transaction calculate-min-fee --tx-body-file fee_draft.txraw --tx-in-count 1 --tx-out-count 2 --witness-count 2 --testnet-magic 1097911063 --protocol-params-file protocol.json | egrep -o '[0-9]+')
```
Following a similar approach in [Transactions: UTxO and Metadata
](https://learn.lovelace.academy/getting-started/transactions-utxo-and-metadata/), we will build a draft Tx with the same arguments to calculate the Tx fee captured in the `FEE` shell variable. This time we are specifying additional arguments in the form of `--mint` and `--minting-script-file`. Also note the `--witness-count` of `2` when we calculate the fee which indicates that we need to sign it with both the source payment key and the policy key. The most difficult part, however, is building the raw Tx with the correct `--mint` and `--tx-out` parameters. 

The format for `--mint` is `{new_custom_token_x_quantity} {policyid}.{asset_name_x}` with additional custom tokens concatenated with a `+`. In this case it is `--mint 1000 7cb31677481b1112db5aaa2acdffbe624d8195d416da8b788cb51f7c.4c4541524e + 1 7cb31677481b1112db5aaa2acdffbe624d8195d416da8b788cb51f7c.4c413235` since they use the same multisig policy.

📝🔥 _**Burn** fungible tokens by using a negative quantity, e.g. `--mint -500 7cb31677481b1112db5aaa2acdffbe624d8195d416da8b788cb51f7c.4c4541524e`_

The format for `--tx-out` is `{address}+{lovelace_quantity}+{custom_token_quantity} {policyid}.{asset_name}` with any additional custom tokens concatenated afterwards. In our simple case the `--tx-in` UTxO does not include any custom tokens so it would contain exactly what is minted after the lovelace quantity. In some other cases (e.g. burning or accumulating custom tokens from other UTxOs) you will need to calculate the custom token quantities if they have been included with the `--tx-in` UTxOs.

### Build Raw Minting Tx 
Now we can build out the actual Tx with the correct fee and using that to calculate the `TXOUT_CHANGE` to go back to the source address. As described in the previous article [Cardano’s Native Assets
](https://learn.lovelace.academy/tokens/introduction-to-tokens/#cardanos-native-assets) we also need to specify a minimum amount of lovelace to send with the custom tokens to the destination address.

```bash
MIN_LOVELACE=1880000
TXOUT_CHANGE=$(expr $UTXO0V - $FEE - $MIN_LOVELACE)

cardano-cli transaction build-raw \
    --tx-in $UTXO0H#$UTXO0I \
    --tx-out $DESTADDR+$MIN_LOVELACE+"$LEARN_QTY $POLICYID.$LEARN_ASSETHEX +$DISCOUNT25_QTY $POLICYID.$DISCOUNT25_ASSETHEX" \
    --tx-out $SOURCEADDR+$TXOUT_CHANGE \
    --metadata-json-file token-metadata.json \
    --mint "$LEARN_QTY $POLICYID.$LEARN_ASSETHEX + $DISCOUNT25_QTY $POLICYID.$DISCOUNT25_ASSETHEX" \
    --minting-script-file ft-policy.script \
    --fee $FEE \
    --out-file mint.txraw
```

### Sign Raw Minting Tx
Note that we are signing the Tx with both `ft-policy.skey` and `source.skey` to provide two witnesses to the Tx.
```bash
cardano-cli transaction sign  \
    --signing-key-file ft-policy.skey  \
    --signing-key-file source.skey  \
    --testnet-magic 1097911063 \
    --tx-body-file mint.txraw  \
    --out-file mint.txsigned
```

### Submit Signed Tx
```
cardano-cli transaction submit --tx-file mint.txsigned --testnet-magic 1097911063
```

### Get Transaction ID
You can also get the transaction ID (aka Tx Hash) of your Tx with the command:
```bash
cardano-cli transaction txid --tx-file mint.txsigned
```
This can be used to verify the result in a testnet block explorer like [Cardanoscan](https://testnet.cardanoscan.io/) or [ADATools](https://testnet.adatools.io/transactions) through a direct search of the transaction ID above.

## Burning Tokens
To burn any quantity of fungible tokens you will need to specify negative values following your `{policyid}.{assetname}` unit in the `--mint` parameter, use the same `--minting-script-file` and ensure the `--tx-out` values factor in the subtracted difference after burning the specified quantities.

## Explore Token Builders
Alternatively you can use the following tools (for a fee) to mint your own tokens without having to use the CLI commands against a full node.
- [Tokhun](https://tokhun.io/account/assets/mint-nft)
- [NFT Maker](https://www.nft-maker.io/)
- [Cardano Token and NFT Builder](https://cardano-native-token.com/)

## Supplementary Material
- [Cardano Docs: Learn about native tokens](https://docs.cardano.org/native-tokens/learn)
- [Cardano Developers: Minting Native Assets](https://developers.cardano.org/docs/native-tokens/minting)
- [Cardano: NerdOut - How to create a FT on Cardano that doesn't completely suck!](https://www.youtube.com/watch?v=pK7xShX9etI)

## Mint your first NFT
Learn how to mint your first NFT at **[NFT Minting Guide ➡️](https://learn.lovelace.academy/tokens/nft-minting-guide/)**
