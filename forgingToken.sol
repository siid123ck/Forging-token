// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";


contract MyERC1155 is ERC1155 {
    uint256 public constant TOKEN_0 = 0;
    uint256 public constant TOKEN_1 = 1;
    uint256 public constant TOKEN_2 = 2;
    uint256 public constant TOKEN_3 = 3;
    uint256 public constant TOKEN_4 = 4;
    uint256 public constant TOKEN_5 = 5;
    uint256 public constant TOKEN_6 = 6;

    mapping(address => uint256) private _balances;

    constructor() ERC1155("") {
        _mint(msg.sender, TOKEN_0, 100, "");
        _mint(msg.sender, TOKEN_1, 100, "");
        _mint(msg.sender, TOKEN_2, 100, "");
    }


    function mint(uint256 tokenId, uint256 amount) public {
        require(tokenId >= 0 && tokenId <= 6, "Invalid token ID");
        _mint(msg.sender, tokenId, amount, "");
    }

    function burn(address account, uint256 tokenId, uint256 amount) public {
        require(tokenId >= 0 && tokenId <= 6, "Invalid token ID");
        _burn(account, tokenId, amount);
    }

    function checkBalance(uint tokenId) internal view returns(uint amount){
        amount = balanceOf(msg.sender, tokenId);
    }

    function forge(uint256 tokenId1, uint256 tokenId2) public {
        require(tokenId1 >= 0 && tokenId1 <= 2, "Invalid token ID");
        require(tokenId2 >= 0 && tokenId2 <= 2, "Invalid token ID");

        uint256 newTokenId;

        if (tokenId1 == 0 && tokenId2 == 1) {
            newTokenId = TOKEN_3;
        } else if (tokenId1 == 1 && tokenId2 == 2) {
            newTokenId = TOKEN_4;
        } else if (tokenId1 == 0 && tokenId2 == 2) {
            newTokenId = TOKEN_5;
        } else if (tokenId1 == 0 && tokenId2 == 1 && tokenId2 == 2) {
            newTokenId = TOKEN_6;
        } else {
            revert("Invalid token combination");
        }

        _mint(msg.sender, newTokenId, 1, "");
    }
}

contract ForgingLogic {
    MyERC1155 private _tokenContract;

    constructor(address tokenContractAddress) {
        _tokenContract = MyERC1155(tokenContractAddress);
    }

    function checkBalance(uint tokenId) public  view returns(uint amount){
        amount = _tokenContract.balanceOf(msg.sender, tokenId);
    }

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    )
        public
        pure
        returns (bytes4)
    {
        return IERC1155Receiver.onERC1155Received.selector;
    }

   function burnAndForge(uint256 tokenId1, uint256 tokenId2) public {
    _tokenContract.burn(msg.sender, tokenId1, 1);
    _tokenContract.burn(msg.sender, tokenId2, 1);

    _tokenContract.forge(tokenId1, tokenId2);
}

}

