interface ISentiment {
    function mint(address to, uint256 amount) external;

    function permit(
        address owner_in,
        address spender,
        uint256 value,
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32 _msg
    ) external;
}
