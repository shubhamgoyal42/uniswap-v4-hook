// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {PerksStoreHook} from "../src/PerksStoreHook.sol";
import {HookMiner} from "../test/utils/HookMiner.sol";
import {IERC165, ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";

contract PerksStoreHookScript is Script {
    address constant CREATE2_DEPLOYER = address(0x4e59b44847b379578588920cA78FbF26c0B4956C);
    address constant PERKSNFT = payable(0x5911C7265d0f16964821D58879e34Cdc7e47Ae7F); // mumbai

    function setUp() public {}

    function run() public {
        IPoolManager manager = IPoolManager(payable(0x5FF8780e4D20e75B8599A9C4528D8ac9682e5c89));
        // IPoolManager manager = IPoolManager(payable(0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9));

        // hook contracts must have specific flags encoded in the address
        uint160 flags = uint160(
            Hooks.BEFORE_SWAP_FLAG
        );

        // Mine a salt that will produce a hook address with the correct flags
        (address hookAddress, bytes32 salt) = HookMiner.find(CREATE2_DEPLOYER, flags, 900, type(PerksStoreHook).creationCode, abi.encode(address(manager)));

        IERC165 checker = IERC165(PERKSNFT);
        bool supportsERC721 = checker.supportsInterface(0x80ac58cd);  // For ERC721

        console.log("########");
        console.log(supportsERC721);


        console.log("########");
        console.log(hookAddress);
        console.logBytes32(salt);

        // Deploy the hook using CREATE2
        vm.broadcast();

        PerksStoreHook perksStoreHook = new PerksStoreHook{salt: salt}(manager);
        require(address(perksStoreHook) == hookAddress, "PerksStoreHookScript: hook address mismatch");
    }
}
