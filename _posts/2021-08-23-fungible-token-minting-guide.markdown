---
layout: post
title: Fungible Token Minting Guide
last_modified_at: 2021-09-08
categories:
- Tokens
order: 3
---
We will break down how to mint fungible tokens in four basic steps:

1. Create Policy Key
2. Define Multisig Policy
3. Create Wallet Keys and Addresses
4. Build and Submit Minting Tx

## Create Policy Key 
A policy key can be generated using the same approach as generating a payment address key as described in our page [Getting Started - Wallet Basics: Keys and Addresses](https://learn.lovelace.academy/getting-started/keys-and-addresses/).
```bash
cardano-cli address key-gen \
    --verification-key-file ft-policy.vkey \
    --signing-key-file ft-policy.skey
```
Capture the hash of the key in the shell variable `POLICYHASH` by running
```bash
POLICYHASH=$(cardano-cli address key-hash --payment-verification-key-file ft-policy.vkey)
```

## Define Multisig Policy
Create a ft-policy.script file with the right script using
```bash
touch ft-policy.script 
echo "{" >> ft-policy.script 
echo "  \"keyHash\": \"$POLICYHASH\"," >> ft-policy.script
echo "  \"type\": \"sig\"" >> ft-policy.script
echo "}" >> ft-policy.script
```
<details>
    <summary>ft-policy.script</summary>
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

## Create Source and Destination Wallet Keys and Addresses
We will then create another set of keys for two wallets. One source wallet to get testnet tADA from the faucet to cover the Tx fee, and one destination wallet to receive the minted tokens. Although in theory you can use the same policy key to generate an address to receive tADA and mint the custom tokens, we recommend using different sets of keys based on their purpose.

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
### Get the Latest Protocol Parameters
The current set of Cardano protocol parameters are required to calculate Tx fees and we can retrieve them into the file `protocol.json` with the following command.

```bash
cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json 
```

### Build draft Tx to Calculate Fee
In this example we are minting two custom tokens under the same `PolicyID` but with a different `asset name`. We initialise the shell variables at the top to specify 1000 `LEARN` tokens and 1 `LA25` token. 
```bash
LEARN_ASSETNAME=LEARN
LEARN_QTY=1000
DISCOUNT25_ASSETNAME=LA25
DISCOUNT25_QTY=1
TXOUT_CHANGE=0

cardano-cli transaction build-raw \
    --tx-in $UTXO0H#$UTXO0I \
    --tx-out $DESTADDR+$UTXO0V+"$LEARN_QTY $POLICYID.$LEARN_ASSETNAME +$DISCOUNT25_QTY $POLICYID.$DISCOUNT25_ASSETNAME" \
    --tx-out $SOURCEADDR+$TXOUT_CHANGE \
    --mint "$LEARN_QTY $POLICYID.$LEARN_ASSETNAME + $DISCOUNT25_QTY $POLICYID.$DISCOUNT25_ASSETNAME" \
    --minting-script-file ft-policy.script \
    --fee 0 \
    --out-file fee_draft.txraw

FEE=$(cardano-cli transaction calculate-min-fee --tx-body-file fee_draft.txraw --tx-in-count 1 --tx-out-count 2 --witness-count 2 --testnet-magic 1097911063 --protocol-params-file protocol.json | egrep -o '[0-9]+')
```
Following a similar approach in [Transactions: UTxO and Metadata
](https://learn.lovelace.academy/getting-started/transactions-utxo-and-metadata/), we build a draft Tx with the same arguments to calculate the Tx fee captured in the `FEE` shell variable. This time we are specifying additional arguments in the form of `--mint` and `--minting-script-file`. Also note the `--witness-count` of `2` when we calculate the fee which indicates that we need to sign it with both the source payment signing key and the policy key.

The most difficult part is building the raw Tx with the correct `--tx-out` and `--mint` parameters. The format for `--tx-out` is `{address}+{lovelace_quantity}+{custom_token_quantity} {policyid}.{asset_name}` with additional custom tokens concatenated afterwards. The format for `--mint` is `--tx-out` without the `{address}+{ada_amount}` in the beginning.

### Build Raw Minting Tx 
Now we can build out the actual Tx with the correct fee and using that to calculate the `TXOUT_CHANGE` to go back to the source address. As described in the previous article [Cardano’s Native Assets
](https://learn.lovelace.academy/tokens/introduction-to-tokens/#cardanos-native-assets) we also need to specify a minimum amount of lovelace to send with the custom tokens to the destination address.

```bash
MIN_LOVELACE=1800000
TXOUT_CHANGE=$(expr $UTXO0V - $fee - $MIN_LOVELACE)

cardano-cli transaction build-raw \
    --tx-in $UTXO0H#$UTXO0I \
    --tx-out $DESTADDR+$MIN_LOVELACE+"$LEARN_QTY $POLICYID.$LEARN_ASSETNAME +$DISCOUNT25_QTY $POLICYID.$DISCOUNT25_ASSETNAME" \
    --tx-out $SOURCEADDR+$TXOUT_CHANGE \
    --mint "$LEARN_QTY $POLICYID.$LEARN_ASSETNAME + $DISCOUNT25_QTY $POLICYID.$DISCOUNT25_ASSETNAME" \
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
This can be used to verify the result in a testnet block explorer like [Cardanoscan](https://testnet.cardanoscan.io/) or [ADATools](https://testnet.adatools.io/transactions) through a direct search.

## Token Builders
Alternatively you can use the following tools (for a fee) to mint your own tokens without having to use the CLI commands against a full node.
- [Tokhun](https://tokhun.io/account/assets/mint-nft)
- [NFT Maker](https://www.nft-maker.io/)
- [Cardano Token and NFT Builder](https://cardano-native-token.com/)
- [EasyCNFT](https://easycnft.art/en)
- [NFT Machine](https://nft-machine.com/)

## Supplementary Material
- [Cardano Docs: Learn about native tokens](https://docs.cardano.org/native-tokens/learn)
- [Cardano Developers Minting Native Assets](https://developers.cardano.org/docs/native-tokens/minting)

## Mint your first NFT
Learn how to mint your first NFT at [NFT Minting Guide ➡️](https://learn.lovelace.academy/tokens/minting-policies/)
