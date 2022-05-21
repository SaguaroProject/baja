#!/usr/bin/bash

__RPC_SERVER_ENABLED__=${BITCOIN_RPC_SERVER_ENABLED:=1}
__RPC_AUTH_CREDENTIALS__="${BITCOIN_RPC_AUTH_CREDENTIALS:='bitcoin:99ab01ce75f87d87f9639645d24a1443$9ef4d35ea95682a25dd8f41663bf53f5ede888ce09255328c7f2fdb129210961'}"
__RPC_ALLOW_IP_ADDRESS__=${BITCOIN_ALLOW_RPC_ADDRESS:=0.0.0.0/0}
__TXINDEX_ENABLED__=${BITCOIN_TXINDEX_ENABLED:=1}
__REGTEST_CHAIN_ENABLED__=${BITCOIN_REGTEST_CHAIN_ENABLED:=1}
__REGTEST_RPC_BIND_ADDRESS__=${BITCOIN_REGTEST_RPC_BIND_ADDRESS:=0.0.0.0}
__REGTEST_PEER_HOST__=${BITCOIN_REGTEST_PEER_HOST:=bitcoin}

BITCOIN_CONFIG=/etc/bitcoin.conf
BITCOIN_DATA_DIR=/var/lib/bitcoind
BITCOIN_DEFAULT_WALLET=default
BITCOIN_CLI="bitcoin-cli -conf=$BITCOIN_CONFIG -datadir=$BITCOIN_DATA_DIR"

#
# Create a new default wallet and mine 101 blocks to "mature" the first 50 BTC block reward
#
function createwallet() {
   $BITCOIN_CLI getwalletinfo > /dev/null 2>&1

   if [ $? -eq 0 ]; then
      echo "\"$BITCOIN_DEFAULT_WALLET\" wallet already exists"
   else
      $BITCOIN_CLI createwallet $BITCOIN_DEFAULT_WALLET false false "" false true true false > /dev/null 2>&1
      $BITCOIN_CLI -rpcwallet=$BITCOIN_DEFAULT_WALLET generatetoaddress 101 $($BITCOIN_CLI getnewaddress) > /dev/null 2>&1
   fi
}

#
# Start the bitcoin daemon
#
function start() {

    #
    # Write environment variables to the config file
    #
    sed -i "s@__TXINDEX_ENABLED__@${__TXINDEX_ENABLED__}@g" $BITCOIN_CONFIG
    
    sed -i "s@__RPC_SERVER_ENABLED__@${__RPC_SERVER_ENABLED__}@g" $BITCOIN_CONFIG
    sed -i "s@__RPC_AUTH_CREDENTIALS__@${__RPC_AUTH_CREDENTIALS__}@g" $BITCOIN_CONFIG
    sed -i "s@__RPC_ALLOW_IP_ADDRESS__@${__RPC_ALLOW_IP_ADDRESS__}@g" $BITCOIN_CONFIG

    sed -i "s@__REGTEST_CHAIN_ENABLED__@${__REGTEST_CHAIN_ENABLED__}@g" $BITCOIN_CONFIG
    sed -i "s@__REGTEST_PEER_HOST__@${__REGTEST_PEER_HOST__}@g" $BITCOIN_CONFIG
    sed -i "s@__REGTEST_RPC_BIND_ADDRESS__@${__REGTEST_RPC_BIND_ADDRESS__}@g" $BITCOIN_CONFIG

    #
    # Start the bitcoin daemon
    #
    /usr/local/bin/bitcoind -conf=$BITCOIN_CONFIG \
                            -datadir=$BITCOIN_DATA_DIR \
                            -fallbackfee=${BITCOIN_FALLBACK_FEE:=0.00001}
}

case "$1" in 
   start)
      start
      ;;
   createwallet)
      createwallet
      ;;
   *)
      echo "Usage: $0 {start|createwallet}"
      exit 1
      ;;
esac

exit 0