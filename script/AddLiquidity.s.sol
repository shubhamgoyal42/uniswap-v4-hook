// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "forge-std/Test.sol";

import "forge-std/console.sol";
import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {IHooks} from "@uniswap/v4-core/contracts/interfaces/IHooks.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {PoolModifyPositionTest} from "@uniswap/v4-core/contracts/test/PoolModifyPositionTest.sol";
import {PerksStoreHook} from "../src/PerksStoreHook.sol";
import {HookMiner} from "../test/utils/HookMiner.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {IERC165, ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {CurrencyLibrary, Currency} from "@uniswap/v4-core/contracts/types/Currency.sol";

import {PoolId, PoolIdLibrary} from "@uniswap/v4-core/contracts/types/PoolId.sol";
import {PoolKey} from "@uniswap/v4-core/contracts/types/PoolKey.sol";


contract AddLiquidityScript is Script {
    using PoolIdLibrary for PoolKey;
    using CurrencyLibrary for Currency;

    PoolKey poolKey;
    PoolId poolId;

    address constant PerksTokenAddress = address(0x703E5426AC4D12Fa49bb8B1d0cf3409Ad6eC102e);
    address constant USDCAddress = address(0x4198467842C864A044F6F563bca85Aa2F5Aa4d42); // custom
    PerksStoreHook constant hook = PerksStoreHook(address(0x086C62046fD044d62AFfd14CE8e50232Cd1Aa74F));

    uint160 constant SQRT_RATIO_1_1 = 79228162514264337593543950336;
    bytes constant ZERO_BYTES = bytes("");
    int24 constant MIN_TICK = -887220;
    int24 constant MAX_TICK = -MIN_TICK;

    function setUp() public {}

    function run() public {

        PoolModifyPositionTest testManager = PoolModifyPositionTest(address(0x092D53306f9Df9eeD35efec24c31Ca32000033BC));

        IERC20 usdcContract = IERC20(USDCAddress);
        IERC20 perksTokenContract = IERC20(PerksTokenAddress);

        // Call the initialize function
        poolKey = PoolKey(Currency.wrap(USDCAddress), Currency.wrap(PerksTokenAddress), 3000, 60, IHooks(hook));
        poolId = poolKey.toId();

        IPoolManager.ModifyPositionParams memory params = IPoolManager.ModifyPositionParams(MIN_TICK, MAX_TICK, 1e18);

        vm.startBroadcast();
        console.log("################## before");
        usdcContract.approve(address(0x092D53306f9Df9eeD35efec24c31Ca32000033BC), 100e18);
        console.log("################## approved 1");
        perksTokenContract.approve(address(0x092D53306f9Df9eeD35efec24c31Ca32000033BC), 100e18);
        console.log("################## approved 2");
        testManager.modifyPosition(poolKey, params, ZERO_BYTES);
        console.log("################## after");
        vm.stopBroadcast();

    }
}
