// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";

contract AddLiquid {
    /**
     *  ADD LIQUIDITY WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1000 USDC and 1 WETH.
     *  Mint a position (deposit liquidity) in the pool USDC/WETH to msg.sender.
     *  The challenge is to provide the same ratio as the pool then call the mint function in the pool contract.
     *
     */
    function addLiquidity(address usdc, address weth, address pool, uint256 usdcReserve, uint256 wethReserve) public {
        IUniswapV2Pair pair = IUniswapV2Pair(pool);
        uint256 USDCBalance = (1000 * 10 ** 6);

        // your code start here

        // see available functions here: https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol

        (uint112 reserve0, uint112 reserve1,) = pair.getReserves();

        // calc amounts to deposit
        // assume deposit full 1000 USDC
        uint256 amountWETHToDeposit = (reserve1 * USDCBalance / reserve0);

        // transfer amounts to contract
        IUniswapV2Pair(usdc).transfer(address(pool), USDCBalance);
        IUniswapV2Pair(weth).transfer(address(pool), amountWETHToDeposit);

        pair.mint(address(msg.sender)); // get LP tokens based on supplied amount
    }
}
