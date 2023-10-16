// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {ERC721OwnershipHook} from "../src/ERC721OwnershipHook.sol";
import {HookMiner} from "../test/utils/HookMiner.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC165, ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";

contract ERC721OwnershipHookScript is Script {
    address constant CREATE2_DEPLOYER = address(0x4e59b44847b379578588920cA78FbF26c0B4956C);
    address constant PERKSNFT = payable(0x8c1a55B3c6629716571234A1935ad2F593853066);

    function setUp() public {}

    function run() public {
        IPoolManager manager = IPoolManager(payable(0x64255ed21366DB43d89736EE48928b890A84E2Cb));
        // IPoolManager manager = IPoolManager(payable(0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9));

        // hook contracts must have specific flags encoded in the address
        uint160 flags = uint160(
            Hooks.BEFORE_SWAP_FLAG
        );

        // Mine a salt that will produce a hook address with the correct flags
        (address hookAddress, bytes32 salt) = HookMiner.find(CREATE2_DEPLOYER, flags, 900, type(ERC721OwnershipHook).creationCode, abi.encode(address(manager)));

        IERC165 checker = IERC165(PERKSNFT);
        bool supportsERC721 = checker.supportsInterface(0x80ac58cd);  // For ERC721

        console.log("########");
        console.log(supportsERC721);


        console.log("########");
        console.log(hookAddress);
        console.logBytes32(salt);

        // Deploy the hook using CREATE2
        vm.broadcast();

        // ERC721OwnershipHook erc721OwnershipHook = new ERC721OwnershipHook{salt: salt}(manager, IERC721(PERKSNFT));
        ERC721OwnershipHook erc721OwnershipHook = new ERC721OwnershipHook{salt: salt}(manager);
        require(address(erc721OwnershipHook) == hookAddress, "ERC721OwnershipHookScript: hook address mismatch");
    }
}
