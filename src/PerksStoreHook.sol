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

/// @title PerksStoreHook
contract PerksStoreHook is BaseHook, Ownable {
    using PoolIdLibrary for PoolKey;

    mapping (address => bool) whitelisedStores;

    error NotWhitelisted();

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) Ownable(msg.sender) {}

    function whitelistStore(address store) public onlyOwner {
        whitelisedStores[store] = true;
    }

    function blacklistStore(address store) public onlyOwner {
        whitelisedStores[store] = false;
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

    // allow only the stores to swap so as not to allow users dump the xp tokens
    function beforeSwap(
        address sender,
        PoolKey calldata,
        IPoolManager.SwapParams calldata,
        bytes calldata
    ) external override returns (bytes4) {
        if (whitelisedStores[sender] != true) {
            revert NotWhitelisted();
        }

        return BaseHook.beforeSwap.selector;
    }
}
