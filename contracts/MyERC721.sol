// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MyERC721 is ERC721Enumerable, ERC721URIStorage, Ownable {

    uint256 public tokenCounter;
    uint256 public maxSupply;

    mapping(uint256 => address) public owners;
    mapping(uint256 => string) private _tokenURIs;

    event CreatedNFT(uint256 indexed tokenId, string tokenURI);

    constructor() ERC721("myNFT", "MNFT")
    {
        tokenCounter = 0;
        maxSupply = 1000;
    }

    function create() public payable
    {
        require (totalSupply() < maxSupply);
        require(msg.value == 0.02*10**18);

        string memory imageURI = getImageURI();
        string memory _tokenURI = formatTokenURI(imageURI);

        _safeMint(msg.sender, tokenCounter);
        _setTokenURI(tokenCounter, _tokenURI);
        emit CreatedNFT(tokenCounter, _tokenURI);

        owners[tokenCounter] = msg.sender;

        tokenCounter += 1;
    }

    function getImageURI() public pure returns (string memory)
    {
        return string("null");
    }

    function formatTokenURI(string memory imageURI) public pure returns (string memory)
    {
        return string(imageURI);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "";
    }

}
