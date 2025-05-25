// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MatchDayNFT is ERC721 {
    uint256 public nextTokenId = 1;
    string private baseTokenURI = "https://aquamarine-reasonable-heron-640.mypinata.cloud/ipfs/bafkreie4avf4bzlybkvr7dixk4dmrxs4phmuou5yqlsnvhtmxcftbhkhb4";

    mapping(address => bool) public hasMinted;

    constructor() ERC721("Champions League Match Day NFT", "CLMD") {}

    function mint() public {
        require(!hasMinted[msg.sender], "You have already minted");

        _safeMint(msg.sender, nextTokenId);
        nextTokenId++;
        hasMinted[msg.sender] = true;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_existsInternal(tokenId), "Token does not exist");
        return baseTokenURI;
    }

    function _existsInternal(uint256 tokenId) internal view returns (bool) {
        return tokenId < nextTokenId;
    }
}
