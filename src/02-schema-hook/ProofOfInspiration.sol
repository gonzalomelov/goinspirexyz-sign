// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { ISPHook } from "@ethsign/sign-protocol-evm/src/interfaces/ISPHook.sol";

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

contract ProofOfInspirationHook is ISPHook, WhitelistMananger {
    IERC20 public usdcToken;

    error SituationNotVerified();
    error InvalidAction();

    constructor(address _usdcToken) WhitelistMananger() {
        usdcToken = IERC20(_usdcToken);
    }

    function _verifySituation(string memory action, address actionAddress, address recipient) internal view {
        if (keccak256(abi.encodePacked(action)) == keccak256(abi.encodePacked("UsdcDonation"))) {
            uint256 balance = usdcToken.balanceOf(actionAddress);
            if (balance == 0) {
                revert SituationNotVerified();
            }
        } else if (keccak256(abi.encodePacked(action)) == keccak256(abi.encodePacked("NftMint"))) {
            IERC721 nftContract = IERC721(actionAddress);
            uint256 balance = nftContract.balanceOf(recipient);
            if (balance == 0) {
                revert SituationNotVerified();
            }
        } else {
            revert InvalidAction();
        }
    }

    function didReceiveAttestation(
        address attester,
        uint64, // schemaId,
        uint64, // attestationId,
        bytes calldata extraData
    )
        external
        payable
    {
        _checkAttesterWhitelistStatus(attester);
        (string memory action, address actionAddress, address recipient) =
            abi.decode(extraData, (string, address, address));
        _verifySituation(action, actionAddress, recipient);
    }

    function didReceiveAttestation(
        address attester,
        uint64, // schemaId,
        uint64, // attestationId,
        IERC20, // resolverFeeERC20Token,
        uint256, // resolverFeeERC20Amount,
        bytes calldata extraData
    )
        external
        view
    {
        _checkAttesterWhitelistStatus(attester);
        (string memory action, address actionAddress, address recipient) =
            abi.decode(extraData, (string, address, address));
        _verifySituation(action, actionAddress, recipient);
    }

    function didReceiveRevocation(
        address attester,
        uint64, // schemaId,
        uint64, // attestationId,
        bytes calldata // extraData
    )
        external
        payable
    {
        // _checkAttesterWhitelistStatus(attester);
    }

    function didReceiveRevocation(
        address attester,
        uint64, // schemaId,
        uint64, // attestationId,
        IERC20, // resolverFeeERC20Token,
        uint256, // resolverFeeERC20Amount,
        bytes calldata // extraData
    )
        external
        view
    {
        // _checkAttesterWhitelistStatus(attester);
    }
}
