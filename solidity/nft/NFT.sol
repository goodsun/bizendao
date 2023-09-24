// SPDX-License-Identifier: Apache License 2.0
pragma solidity ^0.8.0;
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.3/contracts/token/ERC721/ERC721.sol";
import "./RoyaltyStandard.sol";

contract NFT is ERC721, RoyaltyStandard {
    string private _name;
    uint256 private _lastTokenId;
    mapping(uint256 => string) private _metaUrl;
    uint256[] private _tokenIds;

    /*
    * name NFT名称
    * symbol 単位
    */
    constructor(string memory name, string memory symbol) ERC721(name, symbol){
        _name = name;
    }

    /*
    * to 転送先
    * tokenId トークンID
    * metaUrl メタ情報URL
    * _creator 作者アドレス
    * _feeRate ロイヤリティ率 (100 = 1%)
    */
    function mint(address to, uint256 tokenId, string memory metaUrl, address _creator,uint256 _feeRate)
    public {
        require(tokenId == _lastTokenId + 1, "invalid tokenId");
        _lastTokenId ++;
        _metaUrl[tokenId] = metaUrl;
        _tokenIds.push(tokenId);
        _mint(to, tokenId);
        _setTokenRoyalty(tokenId, _creator, _feeRate * 100); //100 = 1%
    }

    /*
    * ERC721 0x80ac58cd
    * ERC165 0x01ffc9a7 (RoyaltyStandard)
    */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, RoyaltyStandard)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
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
