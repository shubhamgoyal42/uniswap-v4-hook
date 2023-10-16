// mock erc721
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MockERC721 is ERC721 {
    constructor() ERC721("MockERC721", "MockERC721") {}

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }
}