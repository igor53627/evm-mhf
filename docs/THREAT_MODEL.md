# Threat Model (MHT)

## What MHT provides

- Raises concrete per-guess cost in offline simulation/enumeration settings.
- Shifts attacker bottleneck toward memory access patterns and bandwidth.

## What MHT does not provide

- Does not change asymptotic dictionary complexity for low-entropy inputs.
- Does not by itself enforce one-on-chain-attempt-per-guess.
- Is not a VDF and does not guarantee strict sequential hardness.
