// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.3;

import { FlashLoanReceiverBase } from "./FlashLoanReceiverBase.sol";
import { ILendingPool } from "./interfaces/ILendingPool.sol";
import { ILendingPoolAddressesProvider } from "./interfaces/ILendingPoolAddressesProvider.sol";
import { IERC20 } from "./interfaces/IERC20.sol";
import './libraries/Libraries.sol';

/** 
    !!!
    Never keep funds permanently on your FlashLoanReceiverBase contract as they could be 
    exposed to a 'griefing' attack, where the stored funds are used by an attacker.
    !!!
 */
abstract contract AaveFlashloan is FlashLoanReceiverBase {
    using SafeMath for uint256;

    /**
        This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    )
        external
        override
        returns (bool)
    {

        //
        // This contract now has the funds requested.
        // Your logic goes here.
        //
        
        // At the end of your logic above, this contract owes
        // the flashloaned amounts + premiums.
        // Therefore ensure your contract has enough to repay
        // these amounts.
        
        // Approve the LendingPool contract allowance to *pull* the owed amount
        for (uint i = 0; i < assets.length; i++) {
            uint amountOwing = amounts[i].add(premiums[i]);
            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
        }
        
        return true;
    }
}