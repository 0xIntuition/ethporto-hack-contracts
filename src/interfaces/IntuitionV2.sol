// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.12;

interface IntuitionV2 {
    function createDescriptorSubject(
        string memory name,
        uint32 bondingConst,
        uint8 objType
    ) external;

    function createClaim(
        string memory attributeName,
        string memory subjectOne,
        string memory subjectTwo,
        bool bidirectional,
        uint32 bondingConst
    ) external;

    function addClaimContext(
        string memory contextName,
        bytes32 claimID,
        uint32 bondingConst
    ) external;

    function initialLockRequired() external view returns (uint256);

    function descriptorExists(
        string memory name,
        uint8 objID
    ) external view returns (bool);

    function claimExists(
        string memory attribute,
        string memory subjectOne,
        string memory subjectTwo,
        bool bidirectional
    ) external view returns (bool);

    function contextExists(
        bytes32 claimID,
        string memory contextName
    ) external view returns (bool);

    // Permitted
    function createClaimWithPermit(
        string memory attributeName,
        string memory subjectOne,
        string memory subjectTwo,
        bool bidirectional,
        uint32 bondingConst,
        address creator,
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32 _msg
    ) external;

    function createDescriptorSubjectWithPermit(
        string memory name,
        uint32 bondingConst,
        uint8 objType,
        address creator,
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32 _msg
    ) external;

    function stakeDescriptorSubjectWithPermit(
        bytes32 descHash,
        uint256 value,
        address creator,
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32 _msg
    ) external;

    function stakeClaimWithPermit(
        bytes32 claimID,
        uint256 value,
        bool counter,
        address creator,
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32 _msg
    ) external;

    function addClaimContextWithPermit(
        string memory contextName,
        bytes32 claimID,
        uint32 bondingConst,
        address creator,
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32 _msg
    ) external;

    function getStakedSharesClaimContext(
        bytes32 claimID, // claim id for <option> <has been voted for> <poll>
        string memory contextName, // "has been voted for"
        bool counter
    ) external returns (uint256 stakedShares);
}
