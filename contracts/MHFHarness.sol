// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {LibMHF} from "./LibMHF.sol";

/// @notice Test/integration harness for LibMHF.
contract MHFHarness {
    function compute(bytes32 input, bytes32 salt) external pure returns (bytes32) {
        return LibMHF.compute(input, salt);
    }
}
