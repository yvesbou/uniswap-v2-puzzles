// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract SimpleSwap {
    /**
     *  PERFORM A SIMPLE SWAP WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap any amount of WETH for USDC token using the `swap` function
     *  from USDC/WETH pool.
     *
     */
    function performSwap(address pool, address weth, address usdc) public {
        /**
         *     swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data);
         *
         *     amount0Out: the amount of USDC to receive from swap.
         *     amount1Out: the amount of WETH to receive from swap.
         *     to: recipient address to receive the USDC tokens.
         *     data: leave it empty.
         */

        // your code start here
        (uint256 reserve0, uint256 reserve1,) = IUniswapV2Pair(pool).getReserves();
        uint256 currentPrice = reserve0 * 1e18 / reserve1;
        uint256 accountForFeesAndSlippage = currentPrice * 95 / 100;
        IERC20(weth).transfer(pool, 1 ether);
        IUniswapV2Pair(pool).swap(accountForFeesAndSlippage, 0, address(this), "");
    }
}
