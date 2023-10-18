// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "forge-std/Test.sol";

import "forge-std/console.sol";
import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {IHooks} from "@uniswap/v4-core/contracts/interfaces/IHooks.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {ERC721OwnershipHook} from "../src/ERC721OwnershipHook.sol";
import {HookMiner} from "../test/utils/HookMiner.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC165, ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {CurrencyLibrary, Currency} from "@uniswap/v4-core/contracts/types/Currency.sol";

import {PoolId, PoolIdLibrary} from "@uniswap/v4-core/contracts/types/PoolId.sol";
import {PoolKey} from "@uniswap/v4-core/contracts/types/PoolKey.sol";


contract CreatePoolScript is Script {
    using PoolIdLibrary for PoolKey;
    using CurrencyLibrary for Currency;

    PoolKey poolKey;
    PoolId poolId;

    address constant PerksToken = address(0xEc0941828C0C8af69525F797efe9512de0b4A51a);
    address constant USDC = address(0x8c1a55B3c6629716571234A1935ad2F593853066); // custom
    ERC721OwnershipHook constant hook = ERC721OwnershipHook(address(0x08E834a760D976ae5d869F795AA8776509B09F03));

    uint160 constant SQRT_RATIO_1_1 = 79228162514264337593543950336;
    bytes constant ZERO_BYTES = bytes("");

    function setUp() public {}

    function run() public {
        IPoolManager manager = IPoolManager(payable(0x5FF8780e4D20e75B8599A9C4528D8ac9682e5c89));

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
