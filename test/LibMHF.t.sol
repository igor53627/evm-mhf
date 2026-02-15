// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../contracts/MHFHarness.sol";

contract LibMHFTest {
    MHFHarness internal mhf = new MHFHarness();

    function testDeterministicSameInputAndSalt() public view {
        bytes32 input = keccak256("input-1");
        bytes32 salt = keccak256("salt-1");

        bytes32 out1 = mhf.compute(input, salt);
        bytes32 out2 = mhf.compute(input, salt);

        require(out1 == out2, "MHF must be deterministic");
    }

    function testInputSensitivity() public view {
        bytes32 salt = keccak256("same-salt");

        bytes32 out1 = mhf.compute(keccak256("input-a"), salt);
        bytes32 out2 = mhf.compute(keccak256("input-b"), salt);

        require(out1 != out2, "different inputs should change output");
    }

    function testSaltSensitivity() public view {
        bytes32 input = keccak256("same-input");

        bytes32 out1 = mhf.compute(input, keccak256("salt-a"));
        bytes32 out2 = mhf.compute(input, keccak256("salt-b"));

        require(out1 != out2, "different salts should change output");
    }

    function testOutputIsNonZeroForSampleVector() public view {
        bytes32 out = mhf.compute(keccak256("sample-input"), keccak256("sample-salt"));
        require(out != bytes32(0), "unexpected zero output");
    }

    function testGasComputeIsMeasurable() public view {
        bytes32 input = keccak256("gas-input");
        bytes32 salt = keccak256("gas-salt");

        uint256 g0 = gasleft();
        bytes32 out = mhf.compute(input, salt);
        uint256 used = g0 - gasleft();

        require(out != bytes32(0), "unexpected zero output");
        require(used > 0, "gas usage should be measurable");
    }
}
