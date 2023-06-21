// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// 定义一个注释结构体，包含中英文注释
struct Comment {
    string chinese;
    string english;
}

contract MyNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // 存储每个NFT的注释，mapping的key是token id
    mapping(uint256 => Comment) private _comments;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function mint(address to, Comment memory comment) public returns (uint256) {
        _tokenIds.increment();

        uint256 newTokenId = _tokenIds.current();
        _mint(to, newTokenId);

        // 存储注释
        _comments[newTokenId] = comment;

        return newTokenId;
    }

    function getComment(uint256 tokenId) public view returns (Comment memory) {
        return _comments[tokenId];
    }
}
