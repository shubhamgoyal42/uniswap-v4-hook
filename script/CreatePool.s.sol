// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "forge-std/Test.sol";

import "forge-std/console.sol";
import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {IHooks} from "@uniswap/v4-core/contracts/interfaces/IHooks.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {PerksStoreHook} from "../src/PerksStoreHook.sol";
import {HookMiner} from "../test/utils/HookMiner.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC165, ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {CurrencyLibrary, Currency} from "@uniswap/v4-core/contracts/types/Currency.sol";
import {PoolModifyPositionTest} from "@uniswap/v4-core/contracts/test/PoolModifyPositionTest.sol";
import {PoolId, PoolIdLibrary} from "@uniswap/v4-core/contracts/types/PoolId.sol";
import {PoolKey} from "@uniswap/v4-core/contracts/types/PoolKey.sol";


contract CreatePoolScript is Script {
    using PoolIdLibrary for PoolKey;
    using CurrencyLibrary for Currency;

    PoolKey poolKey;
    PoolId poolId;

    address constant PerksToken = address(0x703E5426AC4D12Fa49bb8B1d0cf3409Ad6eC102e);
    address constant USDC = address(0x4198467842C864A044F6F563bca85Aa2F5Aa4d42); // custom
    PerksStoreHook constant hook = PerksStoreHook(address(0x086C62046fD044d62AFfd14CE8e50232Cd1Aa74F));

    uint160 constant SQRT_RATIO_1_1 = 79228162514264337593543950336;
    bytes constant ZERO_BYTES = bytes("");

    function setUp() public {}

    function run() public {
        IPoolManager manager = IPoolManager(payable(0x5FF8780e4D20e75B8599A9C4528D8ac9682e5c89));
        // PoolModifyPositionTest testManager = PoolModifyPositionTest(address(0x092D53306f9Df9eeD35efec24c31Ca32000033BC));

        // Call the initialize function
        poolKey = PoolKey(Currency.wrap(USDC), Currency.wrap(PerksToken), 3000, 60, IHooks(hook));
        poolId = poolKey.toId();
        console.log("##################");
        // console.log(Currency.unwrap(poolKey.currency0));
        // console.log(Currency.unwrap(poolKey.currency1));
        // console.log(poolKey.fee);
        console.logBytes32(keccak256(abi.encode(poolKey)));

        vm.broadcast();
        manager.initialize(poolKey, SQRT_RATIO_1_1, ZERO_BYTES);
    }
}
