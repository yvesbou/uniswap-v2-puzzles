// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import "./interfaces/IUniswapV2Pair.sol";

contract AddLiquidWithRouter {
    struct LiquidityParams {
        uint256 reserve0;
        uint256 reserve1;
        uint256 totalAmount;
        uint256 toleratedUSDCAmount;
        uint256 currentPrice;
        uint256 quotedETHAmount;
        uint256 toleratedETHAmount;
    }

    /**
     *  ADD LIQUIDITY WITH ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1000 USDC and 1 ETH.
     *  Mint a position (deposit liquidity) in the pool USDC/ETH to `msg.sender`.
     *  The challenge is to use Uniswapv2 router to add liquidity to the pool.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function addLiquidityWithRouter(address usdcAddress, uint256 deadline) public {
        LiquidityParams memory params;

        (params.reserve0, params.reserve1,) = IUniswapV2Pair(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc).getReserves();

        uint256 slippage = 99; // 1%
        params.totalAmount = IUniswapV2Pair(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
        console.log(params.totalAmount);

        params.toleratedUSDCAmount = params.totalAmount * slippage / 100;
        params.currentPrice = params.reserve0 * 1e18 / params.reserve1; // USDC/ETH price
        console.log(params.currentPrice);

        // amount without slippage
        params.quotedETHAmount = params.totalAmount * 1e6 / params.currentPrice; // x 1e6 to keep precision
        // specify slippage tolerance
        params.toleratedETHAmount = 1e12 * params.quotedETHAmount * slippage / 100; // switch to eth precision for router

        IUniswapV2Pair(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).approve(router, 1000 * 1e6);
        IUniswapV2Router(router).addLiquidityETH{value: 1 ether}(
            usdcAddress, params.totalAmount, params.toleratedUSDCAmount, params.toleratedETHAmount, msg.sender, deadline
        );
    }

    receive() external payable {}
}

interface IUniswapV2Router {
    /**
     *     token: the usdc address
     *     amountTokenDesired: the amount of USDC to add as liquidity.
     *     amountTokenMin: bounds the extent to which the ETH/USDC price can go up before the transaction reverts. Must be <= amountUSDCDesired.
     *     amountETHMin: bounds the extent to which the USDC/ETH price can go up before the transaction reverts. Must be <= amountETHDesired.
     *     to: recipient address to receive the liquidity tokens.
     *     deadline: timestamp after which the transaction will revert.
     */
    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
}
