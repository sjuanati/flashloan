// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.3;

import {IFlashLoanReceiver} from "./interfaces/IFlashLoanReceiver.sol";
import {
    ILendingPoolAddressesProvider
} from "./interfaces/ILendingPoolAddressesProvider.sol";
import {ILendingPool} from "./interfaces/ILendingPool.sol";
import {IERC20} from "./interfaces/IERC20.sol";
import {SafeERC20, SafeMath} from "./libraries/Libraries.sol";

abstract contract FlashLoanReceiverBase is IFlashLoanReceiver {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    ILendingPoolAddressesProvider public immutable /*override*/ ADDRESSES_PROVIDER;
    ILendingPool public immutable /*override*/ LENDING_POOL;

    constructor(ILendingPoolAddressesProvider provider) /*public*/ {
        ADDRESSES_PROVIDER = provider;
        LENDING_POOL = ILendingPool(provider.getLendingPool());
    }
}
