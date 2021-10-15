---
layout: post
title: Minting Policies
last_modified_at: 2021-09-08
categories:
- Tokens
order: 2
---

Minting is the action in which units of a custom token can be **created** or **destroyed** based on validation rules defined in a monetary **policy**. A blockchain with native asset support such as Cardano defines minting policies as a base-layer primitive, permitting anyone holding its principal token (i.e. ADA) to mint custom tokens grouped under a policy identifier.

These `policyID` policy identifiers paired with an `asset name` and details from the official [Token Registry](https://github.com/cardano-foundation/cardano-token-registry/tree/master/mappings) provides all the additional information for a custom token regardless of whether it is Fungible or Non-Fungible. This means that all custom tokens can be traced back to a specific policy and further, the same `policyID` can also be used to create other assets by using different asset names when minting. 

## Multisig aka Native Script Policies
Cardano gives everyone the ability to define [Multisignature (multisig)](https://github.com/input-output-hk/cardano-node/blob/c6b574229f76627a058a7e559599d2fc3f40575d/doc/reference/simple-scripts.md) validation scripts, which grants the ability to spend UTxOs at the corresponding multisig address **only** if the required signatures from one or more keys are provided, and optionally before (or after) a specified time has elapsed. 

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

The multisig script file above can be interpreted as requiring **at least two** signatures out of the three keys, with their hashes defined under the `scripts` array. You can then derive the corresponding multisig address using

```bash
cardano-cli shelley address build-script
  --script-file atleast-2-before-41217687-multisig.script \
  --testnet-magic 1097911063 \
  --out-file atleast-2-before-41217687-multisig.addr \
```

### Generating a Minting Policy
These same validation scripts can also be used to define a minting policy for a native asset. From the script file you can generate the `policyId` using

```bash
cardano-cli transaction policyid \
  --script-file atleast-2-before-41217687-multisig.script
```

 _More to come!_

## Plutus Script Policies
Coming soon

## Fungible vs Non-Fungible 
Non Fungible Tokens (NFTs) provide uniqueness guarantees across the entire blockchain.
This property of uniqueness can be defined in a Multisig policy.

