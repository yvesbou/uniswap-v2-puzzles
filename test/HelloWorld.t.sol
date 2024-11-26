// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {HelloWorld} from "../src/HelloWorld.sol";

contract SaysHelloWorld {
    function name() external returns (string memory) {
        return "Hello World";
    }
}

contract HelloWorldTest is Test {
    HelloWorld public helloWorld;
    SaysHelloWorld public hello;

    function setUp() public {
        helloWorld = new HelloWorld();
        hello = new SaysHelloWorld();
    }

    function test_SayHelloWorld() public {
        string memory greetings = helloWorld.sayHelloWorld(address(hello));

        require(keccak256(abi.encodePacked(greetings)) == keccak256(abi.encodePacked("Hello World")));
    }
}
