// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./mixins/MarketplaceCoreUpgradeable.sol";

contract Marketplace is Initializable, AccessControlEnumerableUpgradeable, MarketplaceCoreUpgradeable {

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        uint256 maxRoyaltyBps,
        uint256 marketFeeBps,
        uint256 marketFeeBurnedBps,
        uint256 marketFeeReflectedBps,
        address treasury,
        address bank,
        uint256 nexBidPercentBps
    ) external initializer {
        __AccessControlEnumerable_init();
        __MarketplaceCore_init(
            maxRoyaltyBps,
            marketFeeBps,
            marketFeeBurnedBps,
            marketFeeReflectedBps,
            treasury,
            bank,
            nexBidPercentBps
        );
    }

    function createERC721Auction(
        address contractAddress, uint256 tokenId, address bidToken,
        uint256 startTime, uint256 duration, uint256 minPrice, uint256 royaltyBps
    ) external {
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = tokenId;
        uint256[] memory values = new uint256[](1);
        values[0] = 1;
        _createSale(_makeSaleInfo(SaleType.AUCTION, contractAddress, TokenType.ERC721, tokenIds, values, bidToken, startTime, duration, minPrice), royaltyBps);
    }

    function createERC1155Auction(
        address contractAddress, uint256 tokenId, uint256 value, address bidToken,
        uint256 startTime, uint256 duration, uint256 minPrice
    ) external {
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = tokenId;
        uint256[] memory values = new uint256[](1);
        values[0] = value;
        _createSale(_makeSaleInfo(SaleType.AUCTION, contractAddress, TokenType.ERC1155, tokenIds, values, bidToken, startTime, duration, minPrice), 0);
    }

    function createERC721FixedPrice(
        address contractAddress, uint256 tokenId, address bidToken,
        uint256 startTime, uint256 duration, uint256 minPrice, uint256 royaltyBps
    ) external {
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = tokenId;
        uint256[] memory values = new uint256[](1);
        values[0] = 1;
        _createSale(_makeSaleInfo(SaleType.FIXED, contractAddress, TokenType.ERC721, tokenIds, values, bidToken, startTime, duration, minPrice), royaltyBps);
    }

    function createERC1155FixedPrice(
        address contractAddress, uint256 tokenId, uint256 value, address bidToken,
        uint256 startTime, uint256 duration, uint256 minPrice
    ) external {
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = tokenId;
        uint256[] memory values = new uint256[](1);
        values[0] = value;
        _createSale(_makeSaleInfo(SaleType.FIXED, contractAddress, TokenType.ERC1155, tokenIds, values, bidToken, startTime, duration, minPrice), 0);
    }

    function createERC1155BundleAuction(
        address contractAddress, uint256[] memory tokenIds, uint256[] memory values, address bidToken,
        uint256 startTime, uint256 duration, uint256 minPrice
    ) external {
        _createSale(_makeSaleInfo(SaleType.AUCTION, contractAddress, TokenType.ERC1155, tokenIds, values, bidToken, startTime, duration, minPrice), 0);
    }

    function createERC1155BundleFixedPrice(
        address contractAddress, uint256[] memory tokenIds, uint256[] memory values, address bidToken,
        uint256 startTime, uint256 duration, uint256 minPrice
    ) external {
        _createSale(_makeSaleInfo(SaleType.FIXED, contractAddress, TokenType.ERC1155, tokenIds, values, bidToken, startTime, duration, minPrice), 0);
    }

    function createERC721Offer(
        address contractAddress, uint256 tokenId, address bidToken,
        uint256 duration, uint256 minPrice
    ) external {
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = tokenId;
        uint256[] memory values = new uint256[](1);
        values[0] = 1;
        _createOffer(_makeOfferInfo(contractAddress, TokenType.ERC721, tokenIds, values, bidToken, duration, minPrice));
    }
}