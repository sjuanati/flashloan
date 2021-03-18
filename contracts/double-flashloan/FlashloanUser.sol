// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;

// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20} from "../aave-flashloan/interfaces/IERC20.sol";
import {FlashloanProvider2} from "./FlashloanProvider.sol";
import {IFlashloanUser2} from "./IFlashloanUser.sol";

contract FlashloanUser2 is IFlashloanUser2 {
    // Variable to be updated if the flashloan works
    // (instead, we should be doing arbritrage or something more profitable ;)
    string public output1;
    string public output2;

    /**
     * @notice  Start the flashloan (triggered by user)
     * @param   flashloan The flashloan contract address
     * @param   amount The amount to be borrowed
     * @param   token The token to be borrowed
     */
    function startFlashloan(
        address flashloan,
        uint256 amount,
        address token
    ) external {
       // Flashload #1 
        FlashloanProvider2(flashloan).executeFlashloan(
            address(this),
            amount,
            token,
            'flash1',
            1
        );
        // Flashloan #2
        FlashloanProvider2(flashloan).executeFlashloan(
            address(this),
            amount,
            token,
            'flash2',
            2
        );
    }

    /**
     * @notice  Callback function to do arbitrage (or whatever) after
     *          receiving the borrowed amount and before returning it
     * @param   amount The amount to be returned
     * @param   token The token to be returned
     * @param   data Arbitrary data
     */
    function flashloanCallback(
        uint256 amount,
        address token,
        string memory data,
        uint256 flashNumber
    ) external override {
        // do some arbitrage, liquidation, etc.
        if (flashNumber == 1) {
            output1 = data;
        } else {
            output2 = data;
        }

        // Reimburse borrowed tokens to Flashloan contract
        IERC20(token).transfer(msg.sender, amount);
    }
}
