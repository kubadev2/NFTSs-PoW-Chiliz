// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChilizCupNFT is ERC721, Ownable {
    uint256 public nextTokenId = 1;
    string private baseTokenURI = "https://aquamarine-reasonable-heron-640.mypinata.cloud/ipfs/bafkreic2jah7mc4vhryiye6rydjj575b3wy5aso7vzvzpzeytstzbnv2nq";

    constructor() ERC721("Chiliz Cup", "ChilizCup") Ownable(msg.sender) {
        _safeMint(msg.sender, nextTokenId);
        nextTokenId++;
    }

    function mint() public onlyOwner {
        _safeMint(msg.sender, nextTokenId);
        nextTokenId++;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_existsInternal(tokenId), "Token does not exist");
        return baseTokenURI;
    }

    function _existsInternal(uint256 tokenId) internal view returns (bool) {
        return tokenId < nextTokenId;
    }
}
