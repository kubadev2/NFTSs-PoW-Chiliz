// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GoldMedalNFT is ERC721, Ownable {
    uint256 public nextTokenId = 1;
    string private baseTokenURI = "https://aquamarine-reasonable-heron-640.mypinata.cloud/ipfs/bafkreidiqk3b7xlj6ktpbtb3oifjpxndkuivst4in2sdjtfqevpwnf7t24";

    mapping(address => bool) public hasMinted;
    address[] public allowedCollections;
    mapping(address => bool) public isAllowedCollection;

    constructor() ERC721("Gold Medal", "GM") Ownable(msg.sender) {
        _addAllowedCollection(0x8CAec4dC4fe4698A6a249fe5Baf62832880aE22C);
        _addAllowedCollection(0xE521d2F53CAF47cEb9302A3C8FcD17c00ae64b54);
        _addAllowedCollection(0xf870601EBA3B16183564cA5F0cfb6263C43C3dBa);
    }

    function mint() public {
        require(!hasMinted[msg.sender], "You have already minted");
        require(_countOwnedNFTs(msg.sender) >= 5, "You need at least 5 NFTs from allowed collections");

        _safeMint(msg.sender, nextTokenId);
        nextTokenId++;
        hasMinted[msg.sender] = true;
    }

    function canMint(address user) external view returns (bool) {
        return !hasMinted[user] && _countOwnedNFTs(user) >= 5;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_existsInternal(tokenId), "Token does not exist");
        return baseTokenURI;
    }

    function _existsInternal(uint256 tokenId) internal view returns (bool) {
        return tokenId < nextTokenId;
    }

    function _countOwnedNFTs(address user) internal view returns (uint256 total) {
        for (uint i = 0; i < allowedCollections.length; i++) {
            total += IERC721(allowedCollections[i]).balanceOf(user);
        }
    }

    function addAllowedCollection(address collection) external onlyOwner {
        require(collection != address(0), "Invalid address");
        require(!isAllowedCollection[collection], "Already added");
        _addAllowedCollection(collection);
    }

    function _addAllowedCollection(address collection) internal {
        allowedCollections.push(collection);
        isAllowedCollection[collection] = true;
    }

    function getAllowedCollections() external view returns (address[] memory) {
        return allowedCollections;
    }
}
