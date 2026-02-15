// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LibMHF
/// @notice Optimized Yul implementation of a memory-hard function for EVM use.
/// @dev Target state: 3 MB (98,304 words), 98,304 mixing iterations.
library LibMHF {
    uint256 internal constant MEMORY_SIZE_WORDS = 98304;
    uint256 internal constant ITERATIONS = 98304;

    /// @notice Computes MHF(input, salt).
    /// @dev Hand-optimized Yul with 8x loop unrolling.
    function compute(bytes32 input, bytes32 salt) internal pure returns (bytes32 output) {
        assembly {
            // ---------------------------------------------------------
            // 1. Memory Management
            // ---------------------------------------------------------
            let bufPtr := mload(0x40)
            let size := MEMORY_SIZE_WORDS
            let iters := ITERATIONS
            let bufSizeBytes := shl(5, size) // 3 MB

            // Scratchpad for hashing at the end of the buffer
            let scratchPtr := add(bufPtr, bufSizeBytes)
            mstore(0x40, add(scratchPtr, 32))

            // ---------------------------------------------------------
            // 2. Fill Phase (8x Unrolled)
            // ---------------------------------------------------------
            mstore(bufPtr, input)
            mstore(add(bufPtr, 32), salt)
            let prev := keccak256(bufPtr, 64)
            mstore(bufPtr, prev)

            let currPtr := add(bufPtr, 32)
            let endPtr := add(bufPtr, bufSizeBytes)
            let limitPtr := sub(endPtr, 224) // Stop 7 words early to avoid overflow (98303 % 8 = 7)

            for {} lt(currPtr, limitPtr) { currPtr := add(currPtr, 256) } {
                prev := keccak256(sub(currPtr, 32), 32)
                mstore(currPtr, prev)
                prev := keccak256(currPtr, 32)
                mstore(add(currPtr, 32), prev)
                prev := keccak256(add(currPtr, 32), 32)
                mstore(add(currPtr, 64), prev)
                prev := keccak256(add(currPtr, 64), 32)
                mstore(add(currPtr, 96), prev)
                prev := keccak256(add(currPtr, 96), 32)
                mstore(add(currPtr, 128), prev)
                prev := keccak256(add(currPtr, 128), 32)
                mstore(add(currPtr, 160), prev)
                prev := keccak256(add(currPtr, 160), 32)
                mstore(add(currPtr, 192), prev)
                prev := keccak256(add(currPtr, 192), 32)
                mstore(add(currPtr, 224), prev)
            }

            // Handle remaining 7 words
            prev := keccak256(sub(currPtr, 32), 32)
            mstore(currPtr, prev)
            prev := keccak256(currPtr, 32)
            mstore(add(currPtr, 32), prev)
            prev := keccak256(add(currPtr, 32), 32)
            mstore(add(currPtr, 64), prev)
            prev := keccak256(add(currPtr, 64), 32)
            mstore(add(currPtr, 96), prev)
            prev := keccak256(add(currPtr, 96), 32)
            mstore(add(currPtr, 128), prev)
            prev := keccak256(add(currPtr, 128), 32)
            mstore(add(currPtr, 160), prev)
            prev := keccak256(add(currPtr, 160), 32)
            mstore(add(currPtr, 192), prev)

            // ---------------------------------------------------------
            // 3. Mixing Phase (8x Unrolled)
            // ---------------------------------------------------------
            for { let i := 0 } lt(i, iters) { i := add(i, 8) } {
                mstore(scratchPtr, xor(prev, mload(add(bufPtr, shl(5, mod(prev, size))))))
                prev := keccak256(scratchPtr, 32)
                mstore(scratchPtr, xor(prev, mload(add(bufPtr, shl(5, mod(prev, size))))))
                prev := keccak256(scratchPtr, 32)
                mstore(scratchPtr, xor(prev, mload(add(bufPtr, shl(5, mod(prev, size))))))
                prev := keccak256(scratchPtr, 32)
                mstore(scratchPtr, xor(prev, mload(add(bufPtr, shl(5, mod(prev, size))))))
                prev := keccak256(scratchPtr, 32)
                mstore(scratchPtr, xor(prev, mload(add(bufPtr, shl(5, mod(prev, size))))))
                prev := keccak256(scratchPtr, 32)
                mstore(scratchPtr, xor(prev, mload(add(bufPtr, shl(5, mod(prev, size))))))
                prev := keccak256(scratchPtr, 32)
                mstore(scratchPtr, xor(prev, mload(add(bufPtr, shl(5, mod(prev, size))))))
                prev := keccak256(scratchPtr, 32)
                mstore(scratchPtr, xor(prev, mload(add(bufPtr, shl(5, mod(prev, size))))))
                prev := keccak256(scratchPtr, 32)
            }

            output := prev
        }
    }
}
