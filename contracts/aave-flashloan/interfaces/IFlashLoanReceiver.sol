// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.3;
pragma experimental ABIEncoderV2;

interface IFlashLoanReceiver {
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external returns (bool);
}
