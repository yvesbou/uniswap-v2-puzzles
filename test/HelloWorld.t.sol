// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test, console} from "forge-std/Test.sol";

import {HelloWorld} from "../src/HelloWorld.sol";

contract SaysHelloWorld {
    function name() external returns (string memory) {
        return "Hello World";
    }
}

contract TestHelloWorld is Test {
    HelloWorld target;
    SaysHelloWorld helper;

    function setUp() public {
        target = new HelloWorld();
        helper = new SaysHelloWorld();
    }

    function testHelloWorld() public {
        string memory response = target.sayHelloWorld(address(helper));
        assertEq(keccak256(abi.encodePacked(response)), keccak256(abi.encodePacked("Hello World")));
    }
}
