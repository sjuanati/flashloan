// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;

interface IFlashloanUser2 {
    function flashloanCallback(
        uint256 amount,
        address token,
        string memory data,
        uint256 flashNumber
    ) external;
}
