// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ERC5192 } from "./ERC5192/ERC5192.sol";

contract SBT is ERC5192 {
  bool private isLocked;
  mapping(uint256 => string) private _metaUrl;

  constructor(string memory _name, string memory _symbol, bool _isLocked)
    ERC5192(_name, _symbol, _isLocked)
  {
    isLocked = _isLocked;
  }

  function safeMint(address to, uint256 tokenId, string memory metaUrl) external {
    _metaUrl[tokenId] = metaUrl;
    _safeMint(to, tokenId);
    if (isLocked) emit Locked(tokenId);
  }

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    _requireMinted(tokenId);
    return string(abi.encodePacked(_metaUrl[tokenId]));
  }
}
