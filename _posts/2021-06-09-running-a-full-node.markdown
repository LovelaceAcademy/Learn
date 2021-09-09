---
layout: post
title: 'Running a Full Cardano Node'
categories:
- 'Getting Started'
last_modified_at: 2021-06-09
order: 2
---

As a developer the best starting point to Cardano is to get a good
understanding of the Cardano node. This knowledge is essential whether
you want to create Dapps, wallets, integration tools, mint custom tokens
or operate your own stake pool.

We will break it down in five basic steps:

1. Set up your Linux environment
2. Clone and build cardano-node
3. Configure the node
4. Running and monitoring the node
5. Interacting with the node using cardano-cli

## Background

The Cardano node is a full node which contains the entire blockchain
since its genesis and acts as the main point of contact from you as
a client to the rest of the nodes in the network. Its main
responsibilities are to:

- Uphold the Ouroboros consensus algorithm
- Maintain the ledger and accounting model
- Expose integration endpoints for clients and nodes

![](/img/node_cardano_components_version_main.png)
Image courtesy of [Cardano docs](https://docs.cardano.org/en/latest/explore-cardano/cardano-architecture-overview/index.html#cardano-blockchain-high-level-architecture)

## Set up Your Linux Environment

At the time of writing, setting up your Cardano development environment
in Ubuntu 20.04 is the easiest and most well-documented approach. There
are a few ways to do so.

- Run Ubuntu as the default OS or dual boot it on your device
- Run Ubuntu as a local VM ([Windows](https://www.youtube.com/watch?v=BatrK6G8j4M), [macOS](https://www.youtube.com/watch?v=Hzji7w882OY))
- Run Ubuntu on a cloud VM via SSH (Windows, macOS)
- Run Ubuntu using WSL2 ([Windows](https://docs.microsoft.com/en-us/windows/wsl/install-win10))

There are pros and cons to each of these options but the most important
outcome is having a **repeatable** and **reliable** way of setting up
your environment from scratch. This will give you confidence in spinning
up a node as required across different networks and purposes.

### Install Core Dependencies

There are several core dependencies to install via APT before you can
build cardano-node.

```bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install git jq wget curl bc make automake g++ build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev libncursesw5 libncurses-dev libtinfo5 libtool autoconf htop net-tools chrony prometheus-node-exporter -y
```

### Install Cabal, GHC and Libsodium

Once the core dependencies are installed we will move on to installing
Cabal (the Haskell build orchestrator), GHC (the Haskell compiler) and
Libsodium (the cryptography library).

```bash
mkdir -p ~/setup/cabal
cd ~/setup/cabal
wget https://downloads.haskell.org/cabal/cabal-install-3.4.0.0/cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz
tar -xf cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz
mkdir -p ~/.local/bin
cp cabal ~/.local/bin/
~/.local/bin/cabal update
~/.local/bin/cabal user-config update
sed -i 's/overwrite-policy:/overwrite-policy: always/g' ~/.cabal/config
mkdir -p ~/setup/ghc
cd ~/setup/ghc
wget https://downloads.haskell.org/~ghc/8.10.4/ghc-8.10.4-x86_64-deb10-linux.tar.xz
tar -xf ghc-8.10.4-x86_64-deb10-linux.tar.xz
cd ghc-8.10.4
./configure
sudo make install
cd ~/git/
git clone https://github.com/input-output-hk/libsodium
cd libsodium
git checkout 66f017f1
./autogen.sh
./configure
make
sudo make install
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
```

## Clone and build cardano-node

Now we can clone the
[cardano-node](https://github.com/input-output-hk/cardano-node)
repository, retrieve the latest tagged version and build it.
This process takes between 10-30 mins so feel free to grab some
tea, coffee and/or snacks.

```bash
cd ~/git
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
git fetch --all --recurse-submodules --tags
git checkout tags/1.29.0
cabal configure --with-compiler=ghc-8.10.4
echo -e "package cardano-crypto-praos\n flags: -external-libsodium-vrf" >> cabal.project.local
~/.local/bin/cabal build all
```

Once that is completed, copy the built binaries to ~/.local/bin 
which will be part of the executable path. 

```bash
cp -p "$(./scripts/bin-path.sh cardano-node)" ~/.local/bin/
cp -p "$(./scripts/bin-path.sh cardano-cli)" ~/.local/bin/
```

### Post-build Scripts

For convenience it also makes sense to add amend the existing
environment variables.

```bash
echo 'export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc
echo 'export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"' >> ~/.bashrc
echo 'export PATH="~/.cabal/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="~/.local/bin:$PATH"' >> ~/.bashrc
echo 'export NODE_HOME="$HOME/testnet-node"' >> ~/.bashrc
echo 'export CARDANO_NODE_SOCKET_PATH="$HOME/testnet-node/socket/node.socket"' >> ~/.bashrc
source ~/.bashrc
```

## Configure the Node

Your Cardano node needs to be configured correctly to connect to
a Cardano network, and this is determined by four JSON configuration
files. We will focus on the testnet first.

```bash
mkdir -p ~/testnet-node/config
mkdir -p ~/testnet-node/socket
cd ~/testnet-node/config
wget -O config.json https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/testnet-config.json
wget -O bgenesis.json https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/testnet-byron-genesis.json
wget -O sgenesis.json https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/testnet-shelley-genesis.json
wget -O agenesis.json https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/testnet-alonzo-genesis.json
wget -O topology.json https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/testnet-topology.json
sed -i 's/"TraceBlockFetchDecisions": false/"TraceBlockFetchDecisions": true/g' config.json
sed -i 's/testnet-shelley-genesis/sgenesis/g' config.json
sed -i 's/testnet-byron-genesis/bgenesis/g' config.json
sed -i 's/testnet-alonzo-genesis/agenesis/g' config.json
```

## Running and Monitoring the Node

Now it just a matter of running your node pointing to the configuration
files above.

```bash
cardano-node run \
--topology ~/testnet-node/config/topology.json \
--database-path ~/testnet-node/db/ \
--socket-path ~/testnet-node/socket/node.socket \
--host-addr 0.0.0.0 \
--port 3001 \
--config ~/testnet-node/config/config.json
```

If you are running the node for the first time it will need to fully
synchronise with the blockchain. Verify that the running node process is
exposing its internal metrics by running:

```bash
curl localhost:12798/metrics | grep [Ee]poch
```

You can see the expected Epoch and Slot by going to 
[testnet.adatools.io](https://testnet.adatools.io/) or visiting
[pooltool.io](https://pooltool.io/) and clicking on the MAINNET button
at the bottom panel until it changes to a red TESTNET button.

## Interacting with the Node using cardano-cli

The `cardano-cli` binary that is copied to the `~/.local/bin` 
path is the main way to interact with your local Cardano node. 
You can run the following commands to familiarise yourself.

```bash
# Getting the current tip
cardano-cli query tip --testnet-magic 1097911063

# Export the protocol parameters to file protocol.json
cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json 
```
