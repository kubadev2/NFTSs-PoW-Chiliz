// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PedroPauletaLegendaryCard is ERC721, Ownable {
    uint256 public nextTokenId = 1;
    string private baseTokenURI = "https://aquamarine-reasonable-heron-640.mypinata.cloud/ipfs/bafkreidjfao4e75qzi37x56yybdv3lfzu7xttazlqmzkvl2wd6s2jsgnfa";

    address public erc20Token = 0xb0Fa395a3386800658B9617F90e834E2CeC76Dd3; // PSG
    uint256 public minTokensRequired = 10;

    mapping(address => bool) public hasMinted;

    constructor() ERC721("Pedro Pauleta Legendary Card", "PPLC") Ownable(msg.sender) {}

    function setRequiredTokenAddress(address newToken) external onlyOwner {
        require(newToken != address(0), "Invalid token address");
        erc20Token = newToken;
    }

    function setMinTokensRequired(uint256 newAmount) external onlyOwner {
        require(newAmount > 0, "Amount must be greater than zero");
        minTokensRequired = newAmount;
    }

    function mint() public {
        require(canMint(msg.sender), "Not eligible to mint");
        _safeMint(msg.sender, nextTokenId);
        nextTokenId++;
        hasMinted[msg.sender] = true;
    }

    function canMint(address user) public view returns (bool) {
        return !hasMinted[user] &&
               IERC20(erc20Token).balanceOf(user) >= minTokensRequired;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_existsInternal(tokenId), "Token does not exist");
        return baseTokenURI;
    }

    function _existsInternal(uint256 tokenId) internal view returns (bool) {
        return tokenId < nextTokenId;
    }
}
