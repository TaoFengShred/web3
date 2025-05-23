// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

contract Immutable {
    // coding convention to uppercase constant variables
    address public immutable MY_ADDRESS;
    uint256 public immutable MY_NUMBER;

    constructor(uint256 _num) {
        MY_ADDRESS = msg.sender;
        MY_NUMBER = _num;
    }
}