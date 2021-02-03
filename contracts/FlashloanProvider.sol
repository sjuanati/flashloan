// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./IFlashloanUser.sol";

contract FlashloanProvider is ReentrancyGuard {
    mapping(address => IERC20) public tokens;

    // array with the addresses of all tokens we support
    constructor(address[] memory _tokens) {
        for (uint256 i = 0; i < _tokens.length; i++) {
            tokens[_tokens[i]] = IERC20(_tokens[i]);
        }
    }

    function executeFlashloan(
        address callback, // address to send the token back
        uint256 amount,
        address _token,
        bytes memory data // arbitrary data to be forwarded to the borrower
    ) external nonReentrant() {
        IERC20 token = tokens[_token]; // pointer to the token to be lent | if we don't have the token, it will be 0
        uint256 originalBalance = token.balanceOf(address(this)); // balance of the Flashloan provider
        require(address(token) != address(0), "token not supported");
        require(originalBalance >= amount, "amount too high");
        token.transfer(callback, amount);
        IFlashloanUser(callback).flashloanCallback(amount, _token, data);
        require(
            token.balanceOf(address(this)) == originalBalance,
            "flashloan not reimbursed"
        );
    }
}
