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
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {IERC165, ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {CurrencyLibrary, Currency} from "@uniswap/v4-core/contracts/types/Currency.sol";
import {PoolModifyPositionTest} from "@uniswap/v4-core/contracts/test/PoolModifyPositionTest.sol";

import {PerksToken} from "src/contracts/PerksToken.sol";
import {USDC} from "src/contracts/USDC.sol";


import {PoolId, PoolIdLibrary} from "@uniswap/v4-core/contracts/types/PoolId.sol";
import {PoolKey} from "@uniswap/v4-core/contracts/types/PoolKey.sol";


contract UniswapTest is Test {
    using PoolIdLibrary for PoolKey;
    using CurrencyLibrary for Currency;

    PoolKey poolKey;
    PoolId poolId;

    address constant PerksTokenAddress = address(0xEc0941828C0C8af69525F797efe9512de0b4A51a);
    address constant USDCAddress = address(0xD9c0C74348C11a1ef99F954576AAB9E6b07455A8); // custom
    PerksStoreHook constant hook = PerksStoreHook(address(0x08E834a760D976ae5d869F795AA8776509B09F03));

    address constant admin = address(0x5d9A0Ae5a863445afe8fB7874C95D85C53e9fe91);

    uint160 constant SQRT_RATIO_1_1 = 79228162514264337593543950336;
    bytes constant ZERO_BYTES = bytes("");
    int24 constant MIN_TICK = -887220;
    // int24 constant MIN_TICK = -7200;
    int24 constant MAX_TICK = -MIN_TICK;

    function setUp() public {}

    function testRun() public {
        // IPoolManager manager = IPoolManager(payable(0x5FF8780e4D20e75B8599A9C4528D8ac9682e5c89));
        PoolModifyPositionTest testManager = PoolModifyPositionTest(address(0x092D53306f9Df9eeD35efec24c31Ca32000033BC));

        IERC20 usdcContract = IERC20(USDCAddress);
        IERC20 perksTokenContract = IERC20(PerksTokenAddress);

        // Call the initialize function
        poolKey = PoolKey(Currency.wrap(USDCAddress), Currency.wrap(PerksTokenAddress), 3000, 60, IHooks(hook));
        poolId = poolKey.toId();

        IPoolManager.ModifyPositionParams memory params = IPoolManager.ModifyPositionParams(MIN_TICK, MAX_TICK, 1e18);

        vm.startPrank(admin);
        console.log("################## before");
        usdcContract.approve(address(0x092D53306f9Df9eeD35efec24c31Ca32000033BC), 100e18);
        console.log("################## approved 1");
        perksTokenContract.approve(address(0x092D53306f9Df9eeD35efec24c31Ca32000033BC), 100e18);
        console.log("################## approved 2");
        testManager.modifyPosition(poolKey, params, ZERO_BYTES);
        console.log("################## after");
        vm.stopPrank();
    }
}
