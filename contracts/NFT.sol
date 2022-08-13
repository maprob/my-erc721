// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721Enumerable, Ownable
{
  using Strings for uint256;

  string baseURI;
  uint timeToReveal;
  uint deployDate;

  string public baseExtension = ".json";
  uint256 public cost = 0.01 ether;
  uint256 public maxSupply = 5;
  uint256 public maxMintAmount = 5;
  bool public paused = false;
  string public notRevealedUri;

  event CreatedNFT(uint256 indexed tokenId, string tokenURI);

  constructor(
    string memory _name,
    string memory _symbol,
    string memory _initBaseURI,
    string memory _initNotRevealedUri,
    uint _timeToReveal
  ) ERC721(_name, _symbol)
  {
    baseURI = _initBaseURI;
    notRevealedUri = _initNotRevealedUri;
    timeToReveal = _timeToReveal;
    deployDate = block.timestamp;
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory)
  {
    return baseURI;
  }

  // public
  function mint(uint256 _mintAmount) public payable
  {
    uint256 supply = totalSupply();
    require(!paused);
    require(_mintAmount > 0);
    require(_mintAmount <= maxMintAmount);
    require(supply + _mintAmount <= maxSupply);

    if (msg.sender != owner())
    {
      require(msg.value >= cost * _mintAmount);
    }

    for (uint256 i = 1; i <= _mintAmount; i++)
    {
      uint256 tokenCount = supply + i;
      _safeMint(msg.sender, tokenCount);
      emit CreatedNFT(tokenCount, tokenURI(tokenCount));
    }
  }

  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    
    if (block.timestamp <= (deployDate + timeToReveal)) {
      return notRevealedUri;
    }

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, "/", tokenId.toString(), baseExtension))
        : "";
  }

  function timeUntilReveal() public view returns (uint)
  {
    return ((deployDate + timeToReveal) - block.timestamp);
  }
 
  function withdraw() public payable onlyOwner
  {
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
  }
}
