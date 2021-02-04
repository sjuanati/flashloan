// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import './FlashloanProvider.sol';
import './IFlashloanUser.sol';

contract FlashloanUser is IFlashloanUser {

    bytes public output;

    function startFlashloan(
        address flashloan,
        uint amount,
        address token,
        bytes memory data
    ) external {
        FlashloanProvider(flashloan).executeFlashloan(
            address(this),
            amount,
            token,
            data
        );
    }

    function flashloanCallback(
        uint amount,
        address token,
        bytes memory data
    ) override external {
        // do some arbitrage, liquidation, etc.
        output = data;
        // Reimburse borrowed tokens to Flashloan contract
        IERC20(token).transfer(msg.sender, amount);
    }
}