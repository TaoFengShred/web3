// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.28;

// Make sure EVM version and VM set to Cancun

// Storage - data is stored on the blockchain
// Memory - data is cleared out after a function call
// Transient storage - data is cleared out after a transaction

interface ITest {
    function val() external view returns (uint256);
    function test() external;
}

contract Callback {
    uint256 public val;

    fallback() external {
        require(msg.sender.code.length > 0);
        val = ITest(msg.sender).val();
    }

    function test(address target) external {
        ITest(target).test();
    }
}

contract TestStorage {
    uint256 public val;

    function test() public {
        uint256 newVal = 123;
        (bool success,) = msg.sender.call("");
        require(success, "Call failed");
        val = newVal;
    }
}

contract TestTransientStorage {
    bytes32 constant SLOT = 0;

    function test() public {
        assembly {
            sstore (SLOT, 321)
        }
        
        (bool success,) = msg.sender.call("");
        require(success, "Call failed");

        assembly {
            sstore (SLOT, 0) 
        }
    }

    function val() public view returns (uint256 v) {
        assembly {
            v := sload(SLOT)
        }
    }
}

contract ReentrancyGuard {
    bool private locked;

    modifier lock() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    // 35313 gas
    function test() public lock {
        // Ignore call error
        (bool success,) = msg.sender.call("");
        require(success, "Call failed");
    }
}

contract ReentrancyGuardTransient {
    bytes32 constant SLOT = 0;

    modifier lock() {
        assembly {
            if sload(SLOT) { 
                revert(0, 0) 
            }
            sstore(SLOT, 1)
        }
        _;
        assembly {
            sstore(SLOT, 0)
        }
    }

    // 21887 gas
    function test() external lock {
        // Ignore call error
        bytes memory b = "";
        (bool success,) = msg.sender.call(b);
        require(success, "Call failed");
    }
}