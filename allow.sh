#!/bin/bash
source .env


export INTUITION_CONTRACT_ADDRESS=$(cat node_modules/@0xintuition/contracts/exports/polygon_mumbai/contracts.json | jq -r .contracts.Intuitionv2.address)
export SENTIMENT_CONTRACT_ADDRESS=$(cat node_modules/@0xintuition/contracts/exports/polygon_mumbai/contracts.json | jq -r .contracts.Sentiment.address)

# allow PollAttest
forge script script/allow.s.sol:Allow --broadcast --rpc-url ${POLYGON_MUMBAI_RPC_URL} --json -vvvv --with-gas-price 15000000000