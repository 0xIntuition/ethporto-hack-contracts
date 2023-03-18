#!/bin/bash
source .env
forge script script/bootstrap.s.sol:BootstrapScript -vvvv --broadcast --rpc-url ${POLYGON_MUMBAI_RPC_URL}
