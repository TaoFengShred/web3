// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import "hardhat/console.sol";

contract Variables {
    // State variables are stored on the blockchain.
    string public text = "Hello";
    uint256 public num = 123;

    function doSomething() public view{
        // Local variables are not saved to the blockchain.
        uint256 inum = 456;

        console.log("inum: %d" , inum);
        
        // Here are some global variables
        uint256 timestamp = block.timestamp; // Current block timestamp

        console.log("timestamp: %d" , timestamp);
        address sender = msg.sender; // address of the caller

        console.log("sender: %s" , sender);
    }
}