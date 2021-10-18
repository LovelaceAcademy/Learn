---
layout: post
title: NFT Minting Guide
last_modified_at: 2021-09-08
categories:
- Tokens
order: 4
---

Using almost the same approach as our [Fungible Token Minting Guide
](https://learn.lovelace.academy/tokens/fungible-token-minting-guide/), we can mint an NFT in four basic steps:

1. Create Token Minting Policy
2. Create Wallet Keys and Addresses
3. Upload Image to IPFS
4. Build and Submit Minting Tx with Metadata

📝 _The main differences involve creating a stricter minting policy, uploading our image to IPFS, and attaching NFT-specific metadata_

## Create Policy Key 
A policy key can be generated using the same approach as generating a payment address key as described in our page [Getting Started - Wallet Basics: Keys and Addresses](https://learn.lovelace.academy/getting-started/keys-and-addresses/).
```bash
cardano-cli address key-gen \
    --verification-key-file nft-policy.vkey \
    --signing-key-file nft-policy.skey
```
Capture the hash of the key in the shell variable `POLICYHASH` by running
```bash
POLICYHASH=$(cardano-cli address key-hash --payment-verification-key-file nft-policy.vkey)
```

## Define Multisig Policy
As mentioned [earlier](https://learn.lovelace.academy/tokens/minting-policies/#fungible-vs-non-fungible), NFTs must guarantee that only one token exists for a `policyID` and `asset name` combination. This can be defined in a Multisig policy with a [time locking script](https://github.com/input-output-hk/cardano-node/blob/c6b574229f76627a058a7e559599d2fc3f40575d/doc/reference/simple-scripts.md#simple-script) to ensure tokens can only be minted **before** a certain time. This applies across the entire policy so in other words, that `policyID` cannot be used to mint any tokens after that time regardless of the `asset name`. 

📝 _Time is denoted in slots since the genesis and a slot is a second as configured for the current protocol version._

Create a nft-policy.script file with the right script using
```bash
SLOTS_BEFORE_EXPIRY=600
EXPIRES_AT_SLOT=$(expr $(cardano-cli query tip --testnet-magic 1097911063 | jq .slot) + $SLOTS_BEFORE_EXPIRY)

touch nft-policy.script 
echo "{" >> nft-policy.script 
echo "  \"type\": \"all\"," >> nft-policy.script 
echo "  \"scripts\":" >> nft-policy.script 
echo "  [" >> nft-policy.script 
echo "   {" >> nft-policy.script 
echo "     \"type\": \"before\"," >> nft-policy.script 
echo "     \"slot\": $EXPIRES_AT_SLOT" >> nft-policy.script 
echo "   }," >> nft-policy.script  
echo "   {" >> nft-policy.script 
echo "     \"type\": \"sig\"," >> nft-policy.script  
echo "     \"keyHash\": \"$POLICYHASH\"" >> nft-policy.script  
echo "   }" >> nft-policy.script 
echo "  ]" >> nft-policy.script  
echo "}" >> nft-policy.script 
```
<details>
    <summary>nft-policy.script</summary>
<pre>
{
  "type": "all",
  "scripts":
  [
   {
     "type": "before",
     "slot": 40194014
   },
   {
     "type": "sig",
     "keyHash": "0f2a601505ecb9f008861c85293a34e2178ecd59c472619c5f895d9b"
   }
  ]
}
</pre>
</details>

You can then capture the policyId of the NFT's multisig policy in the shell variable `POLICYID` by running:

```bash
POLICYID=$(cardano-cli transaction policyid --script-file nft-policy.script)
```
## Create Source and Destination Wallet Keys and Addresses
We will then create another set of keys for two wallets. One source wallet to get testnet tADA from the faucet to cover the Tx fee, and one destination wallet to receive the minted tokens. Although in theory you can use the same policy key to generate an address to receive tADA and mint the custom tokens, we recommend using different sets of keys based on their purpose. 

📝 _In case of mainnet we will know the destination address upfront, so only one set of keys are needed. However as mentioned [earlier](https://learn.lovelace.academy/getting-started/keys-and-addresses/#address-keys), mainnet payment keys should be generated in a trusted air-gapped machine without any network connectivity_

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

## Upload Image to IPFS
Blockchains are not designed nor optimised to store large file blobs so a separate decentralised file storage and content delivery solution is usually required for NFT content that exceed Cardano's 16KB Tx metadata limit. 

📝 _NFTs can also be created using various ingenious methods that can fit within the 16KB Tx metadata payload. Examples of this are [Stellar Hood](https://stellarhood.com/), [CardanoTrees](https://cardanotrees.com/) and upcoming NFTs from [Veritree](https://ito.veritree.com)_


[IPFS](https://ipfs.io/) is the currently accepted solution for storing and serving content in the Web3 world. In order to quickly upload content pinned to IPFS without operating a full node, you can use a freemium service like [Pinata](https://app.pinata.cloud/) and note the `CID` of your uploaded content. This `CID` will be used in the `image` field of your Tx metadata to point your NFT to an IPFS URL. In this example we will use the [Lovelace Academy logo](https://learn.lovelace.academy/img/LALOGO.png) as the image for our NFT.

![](/img/nft-pinata.png)


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

### Build NFT Metadata

Cardano has an [NFT Metadata standard](https://github.com/cardano-foundation/CIPs/blob/master/CIP-0025/CIP-0025.md) which we will use to define the correct metadata for our NFT so that wallets, explorers and other tools can interpret and display it correctly. We will create an `nft-metadata.json` file with the following content and replace `$POLICYID` with the correct policyID from the first step and `$IPFS_CID` with IPFS CID from the third step. Also note to specify the correct `mediaType` if you are using an image format other than image/png.

```
{
        "721": {
            "$POLICYID": {
              "LALOGO": {
                "name": "The Lovelace Academy Logo",
                "description": "Our Logo for the Lovelace Academy NFT Minting Guide",
                "mediaType": "image/png",
                "https": "https://learn.lovelace.academy/tokens/nft-minting-guide/",
                "image": "ipfs://$IPFS_CID"
              }
            }
        }
}
```

### Build draft Tx to Calculate Fee
In this example we are minting one token under our NFT-specific policy with the asset name `LALOGO` and attaching the NFT standard metadata file. 
```bash
NFT_ASSETNAME=LALOGO
MIN_LOVELACE=1880000
TXOUT_CHANGE=$(expr $UTXO0V - $MIN_LOVELACE)

cardano-cli transaction build-raw \
    --tx-in $UTXO0H#$UTXO0I \
    --tx-out $DESTADDR+$MIN_LOVELACE+"1 $POLICYID.$NFT_ASSETNAME" \
    --tx-out $SOURCEADDR+$TXOUT_CHANGE \
    --metadata-json-file nft-metadata.json \
    --mint "1 $POLICYID.$NFT_ASSETNAME" \
    --minting-script-file nft-policy.script \
    --fee 0 \
    --out-file fee_draft.txraw

FEE=$(cardano-cli transaction calculate-min-fee --tx-body-file fee_draft.txraw --tx-in-count 1 --tx-out-count 2 --witness-count 2 --testnet-magic 1097911063 --protocol-params-file protocol.json | egrep -o '[0-9]+')
```
Following a similar approach in [Transactions: UTxO and Metadata
](https://learn.lovelace.academy/getting-started/transactions-utxo-and-metadata/), we build a draft Tx with the same arguments to calculate the Tx fee captured in the `FEE` shell variable. This time we are specifying additional arguments in the form of `--mint` and `--minting-script-file`. Also note the `--witness-count` of `2` when we calculate the fee which indicates that we need to sign it with both the source payment signing key and the policy key.

The most difficult part is building the raw Tx with the correct `--tx-out` and `--mint` parameters. The format for `--tx-out` is `{address}+{lovelace_quantity}+{custom_token_quantity} {policyid}.{asset_name}`. The format for `--mint` is the same as `--tx-out` without the `{address}+{ada_amount}` in the beginning.

### Build Raw Minting Tx 
Now we can build out the actual Tx with the correct fee and using that to calculate the `TXOUT_CHANGE` to go back to the source address. As described in the previous article [Cardano’s Native Assets
](https://learn.lovelace.academy/tokens/introduction-to-tokens/#cardanos-native-assets) we also need to specify a minimum amount of lovelace to send with the custom tokens to the destination address.

```bash
NFT_ASSETNAME=LALOGO
MIN_LOVELACE=1880000
TXOUT_CHANGE=$(expr $UTXO0V - $fee - $MIN_LOVELACE)

cardano-cli transaction build-raw \
    --tx-in $UTXO0H#$UTXO0I \
    --tx-out $DESTADDR+$MIN_LOVELACE+"1 $POLICYID.$NFT_ASSETNAME" \
    --tx-out $SOURCEADDR+$TXOUT_CHANGE \
    --metadata-json-file nft-metadata.json \
    --mint "1 $POLICYID.$NFT_ASSETNAME" \
    --minting-script-file nft-policy.script \
    --fee $FEE \
    --out-file mint.txraw
```

### Sign Raw Minting Tx
Note that we are signing the Tx with both `ft-policy.skey` and `source.skey` to provide two witnesses to the Tx.
```bash
cardano-cli transaction sign  \
    --signing-key-file nft-policy.skey  \
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
- [Tokhun](https://tokhun.io/account/assets/mint-nft)
- [NFT Maker](https://www.nft-maker.io/)
- [Cardano Token and NFT Builder](https://cardano-native-token.com/)
- [EasyCNFT](https://easycnft.art/en)
- [NFT Machine](https://nft-machine.com/)