pragma solidity ^0.8.13;

import {PollAttest} from "../src/PollAttest.sol";
import {ISentiment} from "../src/interfaces/ISentiment.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";

contract Allow is Script {
    address intuition =
        address(
            PollAttest(0xdB91c7AF12dd26adf98FF021d7F58F4E57251B4c).intuition()
        );
    ISentiment sentiment =
        ISentiment(0xa4a4D61AF3BD68567019bD15AE45B994D9060e75);
    PollAttest pollAttest =
        PollAttest(0xdB91c7AF12dd26adf98FF021d7F58F4E57251B4c);

    function setUp() public {}

    function run() public returns (address) {
        uint256 privKey = vm.envUint("ETH_PRIV_KEY");
        vm.startBroadcast(privKey);
        address add = address(0x6b466d9492Dc28FC4a83454d335E53e1a7Dd910D);
        sentiment.mint(address(add), 1000000000000000000000000000);
        sentiment.permit(
            add,
            address(address(pollAttest)),
            1000000000000000000000000000,
            0,
            bytes32(0),
            bytes32(0),
            bytes32(0)
        );
        sentiment.permit(
            add,
            address(intuition),
            1000000000000000000000000000,
            0,
            bytes32(0),
            bytes32(0),
            bytes32(0)
        );

        IERC20(address(sentiment)).approve(intuition, type(uint256).max);
        IERC20(address(sentiment)).approve(
            address(pollAttest),
            type(uint256).max
        );

        vm.stopBroadcast();

        return address(intuition);
    }
}
