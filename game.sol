    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.34;

    import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
    import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

    contract game is ERC1155, Ownable {
        uint256 public tokenId;

        mapping(uint256 => uint256) public maxSupply;

        mapping(uint256 => uint256) public totalMinted;

        constructor(
            address intitalOwner,
            uint256 _tokenId,
            uint256 _maxSupply
        ) ERC1155("") Ownable(intitalOwner) {
            tokenId = _tokenId;
            maxSupply[_tokenId] = _maxSupply;

        }
    }
