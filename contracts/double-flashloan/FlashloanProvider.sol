// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IFlashloanUser2} from "./IFlashloanUser.sol";

contract FlashloanProvider2 is ReentrancyGuard {
    mapping(address => IERC20) public tokens;

    // array with the addresses of all supported tokens
    constructor(address[] memory _tokens) {
        for (uint256 i = 0; i < _tokens.length; i++) {
            tokens[_tokens[i]] = IERC20(_tokens[i]);
        }
    }

    /**
     * @notice  Borrow the amount to the contract caller
     * @dev     If amount is not returned after the callback, the tx will revert
     * @param   callback The contract address to send the token back
     * @param   amount The amount to be borrowed
     * @param   _token The token to be borrowed
     * @param   data Arbitrary data to be forwarded to the borrower
     */
    function executeFlashloan(
        address callback,
        uint256 amount,
        address _token,
        string memory data,
        uint256 flashNumber
    ) external nonReentrant() {
        // pointer to the token to be lent | if we don't have the token, it will be 0
        IERC20 token = tokens[_token];
        // balance of the Flashloan provider
        uint256 originalBalance = token.balanceOf(address(this));
        require(address(token) != address(0), "token not supported");
        require(originalBalance >= amount, "amount too high");
        token.transfer(callback, amount);
        IFlashloanUser2(callback).flashloanCallback(amount, _token, data, flashNumber);
        require(
            token.balanceOf(address(this)) == originalBalance,
            "flashloan not reimbursed"
        );
    }
}
