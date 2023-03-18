// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {PollAttest} from "../src/PollAttest.sol";
import {ISentiment} from "../src/interfaces/ISentiment.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";

contract BootstrapScript is Script {
    ISentiment sentiment =
        ISentiment(0xa4a4D61AF3BD68567019bD15AE45B994D9060e75);
    PollAttest pollAttest =
        PollAttest(0xdB91c7AF12dd26adf98FF021d7F58F4E57251B4c);

    address add = 0x19B0Ca6FA74D691E9B8Be8426B0dfF1Ae56B1a82;

    function run() public {
        uint256 privKey = vm.envUint("ETH_PRIV_KEY");
        vm.startBroadcast(privKey);
        sentiment.mint(address(pollAttest), 1000000000000000000000000000);
        sentiment.mint(address(add), 1000000000000000000000000000);
        sentiment.permit(
            add,
            address(pollAttest),
            1000000000000000000000000000,
            0,
            bytes32(0),
            bytes32(0),
            bytes32(0)
        );
        // create list subjects

        pollAttest.voteOnPoll(
            add,
            "yes",
            "do you like this poll?",
            8,
            bytes32("a"),
            bytes32("a"),
            bytes32("a")
        );
        pollAttest.voteOnPoll(
            add,
            "no",
            "wagmi?",
            8,
            bytes32("a"),
            bytes32("a"),
            bytes32("a")
        );
    }
}
