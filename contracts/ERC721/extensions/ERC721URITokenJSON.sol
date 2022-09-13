// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

/**
 * @dev ERC721 token with storage based token URI management.
 */
abstract contract ERC721URITokenJSON is Initializable {
    using StringsUpgradeable for uint256;

    struct Attribute {
        string name;
        string display;
        string value;
        bool isNumber;
    }

    string public imageBaseURI;
    string public animationBaseURI;

    function __ERC721URITokenJSON_init(
        string memory _imageBaseURI,
        string memory _animationBaseURI
    ) internal onlyInitializing {
        __ERC721URITokenJSON_init_unchained(_imageBaseURI, _animationBaseURI);
    }

    function __ERC721URITokenJSON_init_unchained(
        string memory _imageBaseURI,
        string memory _animationBaseURI
    ) internal onlyInitializing {
        imageBaseURI = _imageBaseURI;
        animationBaseURI = _animationBaseURI;
    }

    function tokenURI(uint256 tokenId) public view virtual returns(string memory);

    function batchTokenURI(uint256[] memory tokenIds) public view virtual returns(string[] memory) {
        string[] memory uris = new string[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uris[i] = tokenURI(tokenIds[i]);
        }
        return uris;
    }

    function _makeBase64(string memory json) internal view virtual returns (string memory) {
        return string(abi.encodePacked("data:application/json;base64,", Base64Upgradeable.encode(bytes(json))));
    }

    function _makeJSON(
        uint256 tokenId,
        string memory name,
        string memory description,
        Attribute[] memory attributes
    ) internal view returns(string memory) {
        string memory metadataJSON = _makeMetadata(tokenId, name, description);
        string memory attributeJSON = _makeAttributes(attributes);
        return string(abi.encodePacked('{', metadataJSON, attributeJSON, '}'));
    }

    function _makeMetadata(
        uint256 tokenId,
        string memory name,
        string memory description
    ) internal view returns(string memory) {
        string memory imageURI = string(abi.encodePacked(imageBaseURI, tokenId.toString()));
        string memory animationURI = string(abi.encodePacked(animationBaseURI, tokenId.toString()));
        return string(abi.encodePacked(
                '"name":"', name, ' #', tokenId.toString(), '",',
                '"description":"', description, '",',
                '"image":"', imageURI, '",',
                '"animation_url":"', animationURI, '",'
            ));
    }

    function _makeAttributes(Attribute[] memory attributes) internal pure returns(string memory) {
        string memory allAttributes = "";
        for (uint256 i = 0; i < attributes.length; i++) {
            string memory comma = i == (attributes.length - 1) ? '' : ',';
            string memory quoted = attributes[i].isNumber ? '' : '"';
            string memory value = string(abi.encodePacked(quoted, attributes[i].value, quoted));
            string memory displayType = bytes(attributes[i].display).length == 0
            ? ''
            :  string(abi.encodePacked('{"display_type":"', attributes[i].display, '",'));
            string memory a = string(
                abi.encodePacked(
                    allAttributes,
                    '{"trait_type":"', attributes[i].name, '",',
                    displayType,
                    '"value":', value, '}',
                    comma
                )
            );
            allAttributes = a;
        }
        return string(abi.encodePacked('"attributes":[', allAttributes, ']'));
    }

    function _setImageBaseURI(string memory _imageBaseURI) internal virtual {
        imageBaseURI = _imageBaseURI;
    }

    function _setAnimationBaseURI(string memory _animationBaseURI) internal virtual {
        animationBaseURI = _animationBaseURI;
    }

    uint256[49] private __gap;
}