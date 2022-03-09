// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "solmate/tokens/ERC721.sol";
import "../utils/Strings.sol";

contract MockERC721 is ERC721 {
    using Strings for uint256;

    uint256 public totalTokens;
    string public baseURI;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseURI_
    ) ERC721(name_, symbol_) {
        baseURI = baseURI_;
    }

    function mint() public {
        super._safeMint(msg.sender, totalTokens);
        totalTokens++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(baseURI, tokenId.toString()));
    }
}
