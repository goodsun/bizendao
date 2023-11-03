// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ERC5192 } from "./ERC5192/ERC5192.sol";

contract SBT is ERC5192 {
  bool private isLocked;
  uint256 private _lastTokenId;
  mapping(uint256 => string) private _metaUrl;
  uint256[] private _tokenIds;

  constructor(string memory _name, string memory _symbol, bool _isLocked)
    ERC5192(_name, _symbol, _isLocked)
  {
    isLocked = _isLocked;
  }

  function mint(address to, uint256 tokenId, string memory metaUrl) external {
    require(tokenId == _lastTokenId + 1, "invalid tokenId");
    _lastTokenId ++;
    _tokenIds.push(tokenId);
    _metaUrl[tokenId] = metaUrl;
    _mint(to, tokenId);
    if (isLocked) emit Locked(tokenId);
  }

  function safeMint(address to, uint256 tokenId, string memory metaUrl) external {
    require(tokenId == _lastTokenId + 1, "invalid tokenId");
    _lastTokenId ++;
    _tokenIds.push(tokenId);
    _metaUrl[tokenId] = metaUrl;
    _safeMint(to, tokenId);
    if (isLocked) emit Locked(tokenId);
  }

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    _requireMinted(tokenId);
    return string(abi.encodePacked(_metaUrl[tokenId]));
  }

  function getTokenIds() public view returns (uint256[] memory){
      return _tokenIds;
  }

  function getNextTokenId() external view returns (uint256){
      return _lastTokenId + 1;
  }

}
