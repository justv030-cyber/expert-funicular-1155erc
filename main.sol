// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.7.0
pragma solidity ^0.8.27;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {ERC1155Burnable} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import {ERC1155Pausable} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";

contract STUBA is ERC1155, Ownable, ERC1155Burnable, ERC1155Pausable {
    uint256 public _nextTokenId;

    mapping(uint256 => uint256) public totalMinted;

    mapping(uint256 => uint256) public maxSupply;

    event ItemMinted(address indexed user, uint256 id, uint256 amount);

    constructor(
        address initialOwner,
        uint256 id,
        uint256 supply
    ) ERC1155("") Ownable(initialOwner) {
        maxSupply[id] = supply;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        require(
            totalMinted[id] + amount <= maxSupply[id],
            "Exceeds maximum supply"
        );
        _mint(account, id, amount, data);
        totalMinted[id] += amount;

        emit ItemMinted(account, id, amount);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        for (uint256 i = 0; i < ids.length; i++) {
            require(
                totalMinted[ids[i]] + amounts[i] <= maxSupply[ids[i]],
                "Exceeds maximum supply"
            );
        }

        _mintBatch(to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; i++) {
            totalMinted[ids[i]] += amounts[i];
            emit ItemMinted(to, ids[i], amounts[i]);
        }
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal override(ERC1155, ERC1155Pausable) {
        super._update(from, to, ids, values);
    }
}
