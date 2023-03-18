// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {PollAttest} from "../src/PollAttest.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import "forge-std/Script.sol";

contract Deploy is Script {
    address intuition = vm.envAddress("INTUITION_CONTRACT_ADDRESS");
    address sentiment = vm.envAddress("SENTIMENT_CONTRACT_ADDRESS");

    function setUp() public {}

    function run() public returns (address) {
        uint256 privKey = vm.envUint("ETH_PRIV_KEY");
        vm.startBroadcast(privKey);
        PollAttest pollAttest = new PollAttest(intuition, sentiment);
        IERC20(sentiment).approve(address(pollAttest), type(uint256).max);
        vm.stopBroadcast();
        return address(pollAttest);
    }
}
