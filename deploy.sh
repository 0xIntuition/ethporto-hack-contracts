#!/bin/bash
source .env


export INTUITION_CONTRACT_ADDRESS=$(cat node_modules/@0xintuition/contracts/exports/polygon_mumbai/contracts.json | jq -r .contracts.Intuitionv2.address)
export SENTIMENT_CONTRACT_ADDRESS=$(cat node_modules/@0xintuition/contracts/exports/polygon_mumbai/contracts.json | jq -r .contracts.Sentiment.address)

# DEPLOY PollAttest
forge script script/deploy.s.sol:Deploy --broadcast --rpc-url ${POLYGON_MUMBAI_RPC_URL} --json
POLLATTEST_CONTRACT_ADDRESS=$(cat broadcast/deploy.s.sol/80001/run-latest.json | jq '.returns."0".value')
POLLATTEST_ABI=$(forge inspect PollAttest abi)
echo "{\"address\": ${POLLATTEST_CONTRACT_ADDRESS}, \"abi\": ${POLLATTEST_ABI} }" > deployments/PollAttest.json