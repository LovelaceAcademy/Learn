---
layout: post
title: Fungible Token Minting Guide
last_modified_at: 2021-09-08
categories:
- Tokens
order: 3
---
We will break it down in four basic steps:

1. Create Policy Key
2. Define Multisig Policy
3. Create Wallet Keys and Addresses
4. Submit Minting Transaction

## Create Policy Key 
A policy key can be generated using the same approach as generating a payment address key as described in our page [Getting Started - Wallet Basics: Keys and Addresses](https://learn.lovelace.academy/getting-started/keys-and-addresses/).
```bash
cardano-cli address key-gen \
    --verification-key-file ft-policy.vkey \
    --signing-key-file ft-policy.skey
```
Note the hash of the key by running
```bash
policyhash=$(cardano-cli address key-hash --payment-verification-key-file ft-policy.vkey)
```

## Define Multisig Policy
Create a ft-policy.script file with the right script using
```bash
touch ft-policy.script 
echo "{" >> ft-policy.script 
echo "  \"keyHash\": \"$policyhash\"," >> ft-policy.script
echo "  \"type\": \"sig\"" >> ft-policy.script
echo "}" >> ft-policy.script
policyid=$(cardano-cli transaction policyid --script-file ft-policy.script)
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

This policy is a simple policy that requires a single signature from the `ft-policy.skey` private signing key.

## Create Source and Destination Wallet Keys and Addresses
We will then create another set of keys for two wallets. One source wallet to mint the fungible tokens, and one destination wallet to receive the minted tokens. Although you can use the same policy key to generate an address to receive ADA and mint the custom tokens, it is recommended to use a different set of keys based on their purpose.

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

sourceaddr=$(cat source.addr)
destaddr=$(cat dest.addr)
```

### Load ADA from Testnet Faucet
Use the [testnet faucet](https://testnets.cardano.org/en/testnets/cardano/tools/faucet/) to send ADA to the generated source wallet address. 

You can then wait a short while and query that the tADA has reached your address by running:
```bash
cardano-cli query utxo \
    --address $(cat source.addr) \
    --testnet-magic 1097911063   
```

## Minting Transaction
By querying the source address that received the 1000 tADA from the faucet, load the relevant UTxO details (hash, index and value) into shell variables.
```bash
UTXO0=$(cardano-cli query utxo --address $sourceaddr --testnet-magic 1097911063 | sed -n 3p)
UTXO0H=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 1p)
UTXO0I=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 2p)
UTXO0V=$(echo $UTXO0 | egrep -o '[a-z0-9]+' | sed -n 3p)    
```
### Get the Latest Protocol Parameters
```bash
cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json 
```

### Build draft Tx to Calculate Fee
In this example we are minting two custom tokens using the same `policyid`, 1000 `learn` tokens and 1 `la25` token. 
```bash
learnassetname=learn
learnqty=1000
discount25assetname=la25
discount25qty=1
txoutchange=0

cardano-cli transaction build-raw \
    --tx-in $UTXO0H#$UTXO0I \
    --tx-out $destaddr+$UTXO0V+"$learnqty $policyid.$learnassetname +$discount25qty $policyid.$discount25assetname" \
    --tx-out $sourceaddr+$txoutchange \
    --mint "$learnqty $policyid.$learnassetname + $discount25qty $policyid.$discount25assetname" \
    --minting-script-file ft-policy.script \
    --fee 0 \
    --out-file fee_draft.txraw

fee=$(cardano-cli transaction calculate-min-fee --tx-body-file fee_draft.txraw --tx-in-count 1 --tx-out-count 2 --witness-count 2 --testnet-magic 1097911063 --protocol-params-file protocol.json | egrep -o '[0-9]+')
```
The trickiest part is building the Tx with the correct `--tx-out` and `--mint` parameters. The format for `--tx-out` is `{address}+{ada_amount}+{custom_token_quantity} {policyid}.{asset_name}` with additional custom tokens concatenated afterwards. The format for `--mint` is `--tx-out` without the `{address}+{ada_amount}`.

### Build Raw Minting Tx 
```bash
mindestinationlovelace=1800000
txoutchange=$(expr $UTXO0V - $fee - $mindestinationlovelace)

cardano-cli transaction build-raw \
    --tx-in $UTXO0H#$UTXO0I \
    --tx-out $destaddr+$mindestinationlovelace+"$learnqty $policyid.$learnassetname +$discount25qty $policyid.$discount25assetname" \
    --tx-out $sourceaddr+$txoutchange \
    --mint "$learnqty $policyid.$learnassetname + $discount25qty $policyid.$discount25assetname" \
    --minting-script-file ft-policy.script \
    --fee $fee \
    --out-file mint.txraw
```

### Sign Raw Minting Tx
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

## Token Builders
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
