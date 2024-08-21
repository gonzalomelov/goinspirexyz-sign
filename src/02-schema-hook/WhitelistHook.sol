// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";
import { ISPHook } from "@ethsign/sign-protocol-evm/src/interfaces/ISPHook.sol";

// @dev This contract manages the whitelist. We are separating the whitelist logic from the hook to make things easier
// to read.
contract WhitelistMananger is Ownable {
    mapping(address attester => bool allowed) public whitelist;

    error UnauthorizedAttester();

    constructor() Ownable(_msgSender()) { }

    function setWhitelist(address attester, bool allowed) external onlyOwner {
        whitelist[attester] = allowed;
    }

    function _checkAttesterWhitelistStatus(address attester) internal view {
        // solhint-disable-next-line custom-errors
        require(whitelist[attester], UnauthorizedAttester());
    }
}

// @dev This contract implements the actual schema hook.
contract WhitelistHook is ISPHook, WhitelistMananger {
    function didReceiveAttestation(
        address attester,
        uint64, // schemaId
        uint64, // attestationId
        bytes calldata // extraData
    )
        external
        payable
    {
        _checkAttesterWhitelistStatus(attester);
    }

    function didReceiveAttestation(
        address attester,
        uint64, // schemaId
        uint64, // attestationId
        IERC20, // resolverFeeERC20Token
        uint256, // resolverFeeERC20Amount
        bytes calldata // extraData
    )
        external
        view
    {
        _checkAttesterWhitelistStatus(attester);
    }

    function didReceiveRevocation(
        address attester,
        uint64, // schemaId
        uint64, // attestationId
        bytes calldata // extraData
    )
        external
        payable
    {
        _checkAttesterWhitelistStatus(attester);
    }

    function didReceiveRevocation(
        address attester,
        uint64, // schemaId
        uint64, // attestationId
        IERC20, // resolverFeeERC20Token
        uint256, // resolverFeeERC20Amount
        bytes calldata // extraData
    )
        external
        view
    {
        _checkAttesterWhitelistStatus(attester);
    }
}
