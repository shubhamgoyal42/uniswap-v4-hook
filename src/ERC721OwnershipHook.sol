// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {BaseHook} from "v4-periphery/BaseHook.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {PoolKey} from "@uniswap/v4-core/contracts/types/PoolKey.sol";
import {PoolIdLibrary} from "@uniswap/v4-core/contracts/types/PoolId.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title ERC721OwnershipHook
contract ERC721OwnershipHook is BaseHook, Ownable {
    using PoolIdLibrary for PoolKey;

    /// @notice NFT contract
    IERC721 public nftContract;

    error NotNftOwner();

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) Ownable(msg.sender) {}

    function setNFT(IERC721 _nftContract) public onlyOwner {
        nftContract = _nftContract;
    }

    function getHooksCalls() public pure override returns (Hooks.Calls memory) {
        return
            Hooks.Calls({
                beforeInitialize: false,
                afterInitialize: false,
                beforeModifyPosition: false,
                afterModifyPosition: false,
                beforeSwap: true,
                afterSwap: false,
                beforeDonate: false,
                afterDonate: false
            });
    }

    function beforeSwap(
        address sender,
        PoolKey calldata,
        IPoolManager.SwapParams calldata,
        bytes calldata
    ) external override returns (bytes4) {
        if (nftContract.balanceOf(sender) == 0) {
            revert NotNftOwner();
        }

        return BaseHook.beforeSwap.selector;
    }
}
