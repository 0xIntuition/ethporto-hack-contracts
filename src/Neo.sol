// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {IntuitionV2} from "./interfaces/IntuitionV2.sol";

contract Neo {
    IntuitionV2 public intuition;

    IERC20 sentiment;
    uint32 BONDING_CURVE = 500000;

    constructor(address _intuition, address _sentiment) {
        intuition = IntuitionV2(_intuition);
        sentiment = IERC20(_sentiment);
        sentiment.approve(_intuition, type(uint256).max);
    }

    function vote(
        string memory poll,
        string memory option,
        address user,
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32 _msg
    ) public {
        if (!intuition.descriptorExists("vote cast in poll", 0)) {
            // Create descriptor for connection
            intuition.createDescriptorSubjectWithPermit(
                "vote cast in poll",
                BONDING_CURVE,
                0,
                user,
                v,
                r,
                s,
                _msg
            );
        }

        if (!intuition.descriptorExists(option, 1)) {
            // Create descriptor for context (user)
            intuition.createDescriptorSubjectWithPermit(
                poll,
                BONDING_CURVE,
                1,
                user,
                v,
                r,
                s,
                _msg
            );
        }

        if (!intuition.claimExists("vote cast in poll", poll, "", false)) {
            intuition.createClaimWithPermit(
                "vote cast in poll",
                poll,
                "",
                false,
                BONDING_CURVE,
                user,
                v,
                r,
                s,
                _msg
            );
        }

        bytes32 claimId = keccak256(
            bytes(string.concat("vote cast in poll", ".", poll, ".", ""))
        );

        if (!intuition.contextExists(claimId, option)) {
            intuition.addClaimContextWithPermit(
                option,
                claimId,
                BONDING_CURVE,
                user,
                v,
                r,
                s,
                _msg
            );
        }
    }

    function results(
        string memory poll,
        string[] memory options
    ) public returns (uint256[] memory) {
        // Get all the votes for each option
        // Get the total votes for the poll
        // Calculate the percentage of votes for each option
        uint256[] memory results = new uint256[](options.length);

        for (uint i = 0; i < options.length; i++) {
            bytes32 claimId = keccak256(
                bytes(string.concat("vote cast in poll", ".", poll, ".", ""))
            );
            results[i] = intuition.getStakedSharesClaimContext(
                claimId,
                options[i],
                false
            );
        }

        return results;
    }
}
