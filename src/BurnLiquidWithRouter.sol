// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IERC20.sol";
import "./interfaces/IUniswapV2Pair.sol";

import {Test, console} from "forge-std/Test.sol";

contract BurnLiquidWithRouter {
    /**
     *  BURN LIQUIDITY WITH ROUTER EXERCISE
     *
     *  The contract has an initial balance of 0.01 UNI-V2-LP tokens.
     *  Burn a position (remove liquidity) from USDC/ETH pool to this contract.
     *  The challenge is to use Uniswapv2 router to remove all the liquidity from the pool.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function burnLiquidityWithRouter(address pool, address usdc, address weth, uint256 deadline) public {
        // your code start here
        uint256 lpTokens = IUniswapV2Pair(pool).balanceOf(address(this));
        (uint256 reserve0, uint256 reserve1,) = IUniswapV2Pair(pool).getReserves();
        console.log(reserve0);
        console.log(reserve1);
        uint256 totalLPTokens = IUniswapV2Pair(pool).totalSupply(); // amount of LP tokens
        uint256 share = lpTokens * 1e18 / totalLPTokens;
        console.log(share);
        console.log(totalLPTokens);
        uint256 amountUSDC = share * reserve0 / (1e6 * 1e12); // share has 12 precision points too much, and account for multiplying 1e6 precision
        uint256 amountWETH = share * reserve1 / 1e18;
        IUniswapV2Pair(pool).approve(router, 1e16);
        IUniswapV2Router(router).removeLiquidity(usdc, weth, lpTokens, amountUSDC, amountWETH, address(this), deadline);
    }
}

interface IUniswapV2Router {
    /**
     *     tokenA: the address of tokenA, in our case, USDC.
     *     tokenB: the address of tokenB, in our case, WETH.
     *     liquidity: the amount of LP tokens to burn.
     *     amountAMin: the minimum amount of amountA to receive.
     *     amountBMin: the minimum amount of amountB to receive.
     *     to: recipient address to receive tokenA and tokenB.
     *     deadline: timestamp after which the transaction will revert.
     */
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);
}
