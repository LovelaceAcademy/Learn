---
layout: post
title: Minting Policies
last_modified_at: 2021-09-08
categories:
- Tokens
order: 2
---

Minting is the action in which units of a custom token can be **created** or **destroyed** based on validation rules defined in a monetary **policy**. A blockchain with native asset support such as Cardano defines minting policies as a base-layer primitive, permitting anyone holding its principal token (i.e. ADA) to mint any number of custom tokens grouped under a `policyID` policy identifier and a specified `asset name`.

## Fungible vs Non-Fungible 

The combination of `policyID`, `asset name`, metadata from the minting Tx, and details from the official [Token Registry](https://github.com/cardano-foundation/cardano-token-registry) provides all the additional information for a custom token regardless of whether it is Fungible or Non-Fungible. The main difference is that Non Fungible Tokens (NFTs) provide uniqueness guarantees across the entire blockchain. This property of uniqueness can be defined using Multisig or Plutus Script policies to ensure that **only one** token exists under the `policyID` and `asset name` combination. 

## Multisig Policies

### Introduction to Multisig
Cardano gives everyone the ability to define [Multisignature (multisig)](https://github.com/input-output-hk/cardano-node/blob/c6b574229f76627a058a7e559599d2fc3f40575d/doc/reference/simple-scripts.md) validation scripts, which defines that an action can be permitted **only** if the required signatures from one or more keys are provided, and optionally before (or after) a specified time has elapsed. These multisig scripts govern which keys and when values can be spent or claimed from payment addresses and stake/reward addresses respectively. 

Multisig scripts are simply JSON files such as the following example `atleast-2-before-41217687.script`.

```json
{
    "scripts": [
        {
            "keyHash": "e09d36c79dec9bd1b3d9e152247701cd0bb860b5ebfd1de8abb6735a",
            "type": "sig"
        },
        {
            "keyHash": "a687dcc24e00dd3caafbeb5e68f97ca8ef269cb6fe971345eb951756",
            "type": "sig"
        },
        {
            "keyHash": "0bd1d702b2e6188fe0857a6dc7ffb0675229bab58c86638ffa87ed6d",
            "type": "sig"
        },
        {
            "slot": 41217687,
            "type": "before"
        }
    ],
    "required": 2,
    "type": "atLeast"
}
```

The multisig script file above can be interpreted as requiring **at least two** signatures out of the three keys, with their hashes defined under the `scripts` array. You can then derive the corresponding multisig payment address using:

```bash
cardano-cli shelley address build-script
  --script-file atleast-2-before-41217687-multisig.script \
  --testnet-magic 1097911063 \
  --out-file atleast-2-before-41217687-multisig.addr \
```

### Generating a Multisig Minting Policy
These same validation scripts can also be used to define a minting policy for a native asset. From the script file you can generate the `policyId` using

```bash
cardano-cli transaction policyid \
  --script-file atleast-2-before-41217687-multisig.script
```

## Plutus Script Policies
Multisig policies allow us to define basic validation rules based on a set of keys and a given point in time, but with Plutus Script based policies you can define a much more comprehensive set of minting rules. 

_More content coming soon..._

## Mint your own Token
Learn how to mint your first fungible token at [Fungible Token Minting Guide ➡️](https://learn.lovelace.academy/tokens/fungible-token-minting-guide/)

