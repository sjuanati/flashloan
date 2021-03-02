// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;

// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20} from "../aave-flashloan/interfaces/IERC20.sol";
import {FlashloanProvider} from "./FlashloanProvider.sol";
import {IFlashloanUser} from "./IFlashloanUser.sol";

contract FlashloanUser is IFlashloanUser {
    // Variable to be updated if the flashloan works
    // (instead, we should be doing arbritrage or something more profitable ;)
    bytes public output;

    /**
     * @notice  Start the flashloan (triggered by user)
     * @param   flashloan The flashload contract address
     * @param   amount The amount to be borrowed
     * @param   token The token to be borrowed
     * @param   data Arbitrary data
     */
    function startFlashloan(
        address flashloan,
        uint256 amount,
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

    /**
     * @notice  Callback function to do arbitrage (or whatever) after
     *          receiving the borrowed amount and before returing it
     * @param   amount The amount to be returned
     * @param   token The token to be returned
     * @param   data Arbitrary data
     */
    function flashloanCallback(
        uint256 amount,
        address token,
        bytes memory data
    ) external override {
        // do some arbitrage, liquidation, etc.
        output = data;
        // Reimburse borrowed tokens to Flashloan contract
        IERC20(token).transfer(msg.sender, amount);
    }
}
