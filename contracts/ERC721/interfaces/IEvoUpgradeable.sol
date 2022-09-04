// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "./IEvoStructsUpgradeable.sol";

interface IEvoUpgradeable is IEvoStructsUpgradeable {
    function mint(address _address, Evo memory evo) external;
    function batchMint(address _address, Evo[] memory evos) external;
    function getPendingHatchFor(address _address) external view returns(PendingHatch memory);
    function clearPendingHatch(address _address) external;
    function batchSetAttribute(uint256 tokenId, uint256[] memory attributeIds, uint256[] memory values) external;
    function batchAddToAttribute(uint256 tokenId, uint256[] memory attributeIds, uint256[] memory values) external;
    function tokensOfOwner(address owner) external view returns(uint256[] memory);
    function batchTokenUriJson(uint256[] memory tokenIds) external view returns(string[] memory);
}