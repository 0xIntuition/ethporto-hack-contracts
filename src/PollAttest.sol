// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IntuitionV2} from "./interfaces/IntuitionV2.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import "forge-std/console2.sol";

contract PollAttest {
    IntuitionV2 public intuition;

    string public OPTION_POLL_CONNECTION_DESCRIPTOR = "in poll";
    IERC20 sentiment;
    uint32 BONDING_CURVE = 500000;

    event VotedOnPoll(address user, string option, string poll);
    event Staked(
        address user,
        string subject,
        string descriptor,
        string context,
        uint256 amount,
        bool counter
    );

    constructor(address _intuition, address _sentiment) {
        intuition = IntuitionV2(_intuition);
        sentiment = IERC20(_sentiment);
        sentiment.approve(_intuition, type(uint256).max);
    }

    function stake(
        address user,
        string memory subject,
        string memory descriptor,
        string memory context,
        bool counter,
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32 _msg
    ) public {
        if (!intuition.descriptorExists(descriptor, 0)) {
            // Create descriptor for connection
            intuition.createDescriptorSubjectWithPermit(
                descriptor,
                BONDING_CURVE,
                0,
                user,
                v,
                r,
                s,
                _msg
            );
            console2.log("Created descriptor for connection");
        }

        if (!intuition.descriptorExists(subject, 1)) {
            // Create descriptor for connection
            intuition.createDescriptorSubjectWithPermit(
                subject,
                BONDING_CURVE,
                1,
                user,
                v,
                r,
                s,
                _msg
            );
            console2.log("Created descriptor for subject");
        }

        if (!intuition.claimExists(descriptor, subject, "", false)) {
            intuition.createClaimWithPermit(
                descriptor,
                subject,
                "",
                false,
                BONDING_CURVE,
                user,
                v,
                r,
                s,
                _msg
            );
            console2.log("Created claim");
        }

        // Stake or Counterstake

        // Add context to claim (user)
        // keccak the claimId
        string memory claimIdString = string.concat(
            descriptor,
            ".",
            subject,
            "."
        );

        bytes32 claimId = keccak256(bytes(claimIdString));

        intuition.stakeClaimWithPermit(
            claimId,
            1,
            counter,
            user,
            v,
            r,
            s,
            _msg
        );
        console2.log("Staked claim");

        if (bytes(context).length != 0) {
            if (!intuition.contextExists(claimId, context)) {
                // Add the claim context
                intuition.createDescriptorSubjectWithPermit(
                    context,
                    BONDING_CURVE,
                    0,
                    user,
                    v,
                    r,
                    s,
                    _msg
                );
                console2.log("Created descriptor for context");
            }
            intuition.addClaimContextWithPermit(
                context,
                claimId,
                BONDING_CURVE,
                user,
                v,
                r,
                s,
                _msg
            );
            console2.log("Added claim context");
        }

        emit Staked(user, subject, descriptor, context, 1, counter);
    }

    function voteOnPoll(
        address user,
        string memory option,
        string memory poll,
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32 _msg
    ) public {
        if (!intuition.descriptorExists(OPTION_POLL_CONNECTION_DESCRIPTOR, 0)) {
            // Create descriptor for connection
            intuition.createDescriptorSubjectWithPermit(
                OPTION_POLL_CONNECTION_DESCRIPTOR,
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
                option,
                BONDING_CURVE,
                1,
                user,
                v,
                r,
                s,
                _msg
            );
        }

        if (!intuition.descriptorExists(poll, 1)) {
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

        //TODO: passthrough permit
        if (
            !intuition.claimExists(
                OPTION_POLL_CONNECTION_DESCRIPTOR,
                option,
                poll,
                false
            )
        ) {
            intuition.createClaimWithPermit(
                OPTION_POLL_CONNECTION_DESCRIPTOR,
                option,
                poll,
                false,
                BONDING_CURVE,
                user,
                v,
                r,
                s,
                _msg
            );
        }

        emit VotedOnPoll(user, option, poll);
    }
}
