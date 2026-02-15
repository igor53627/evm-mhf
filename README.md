# evm-mht

EVM-native memory-hard function primitive.

## Scope

This repository contains:
- `contracts/LibMHF.sol`: 3 MB Keccak-based memory-hard function
- `contracts/MHFHarness.sol`: thin harness for testing/integration
- `test/LibMHF.t.sol`: deterministic/sensitivity/gas sanity tests

## Security model

- Purpose: increase concrete per-guess cost for offline dictionary attacks.
- No entropy amplification: low-entropy secrets remain dictionary-bound.
- This is a cost-throttling primitive, not a proof of sequential hardness.

## Build and test

```bash
forge test
```

## Integration example

```solidity
import {LibMHF} from "evm-mht/LibMHF.sol";

bytes32 mhtOut = LibMHF.compute(input, salt);
```
