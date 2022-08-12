// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyERC721 is ERC721Enumerable, ERC721URIStorage, Ownable {

    string baseURI;
    string public baseExtension = ".json";
    uint256 public tokenCounter = 0;
    uint256 public maxSupply = 5;
    uint256 public cost = 0.001 ether;

    mapping(uint256 => address) public owners;
    mapping(uint256 => string) private _tokenURIs;

    event CreatedNFT(uint256 indexed tokenId, string tokenURI);

    constructor (
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI
    )
    ERC721(_name, _symbol)
    {
        baseURI = _initBaseURI;
    }

    function create() public payable
    {
        require(totalSupply() < maxSupply);
        require(msg.value >= cost);

        string memory _tokenURI = tokenURI(tokenCounter);

        _safeMint(msg.sender, tokenCounter);
        _setTokenURI(tokenCounter, _tokenURI);
        emit CreatedNFT(tokenCounter, _tokenURI);

        owners[tokenCounter] = msg.sender;
        tokenCounter += 1;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, "/", Strings.toString(tokenCounter), baseExtension))
            : "";
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

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _baseURI() internal view virtual override returns (string memory)
    {
        return baseURI;
    }

    function withdraw() public payable onlyOwner
    {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }

}
