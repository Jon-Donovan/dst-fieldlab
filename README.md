# DST FieldLab

DST FieldLab is a configurable gameplay laboratory for Don't Starve Together.
Its purpose is to reduce setup friction when studying, reproducing, and testing
specific gameplay mechanics.

## Current milestone: Tools v2

This clean baseline modifies only the standard:

- Axe (`axe` / `ACTIONS.CHOP`)
- Pickaxe (`pickaxe` / `ACTIONS.MINE`)
- Shovel (`shovel` / `ACTIONS.DIG`)
- Hammer (`hammer` / `ACTIONS.HAMMER`)

Each tool can be independently enabled. Shared settings control:

- work efficiency;
- work-action durability consumption;
- weapon damage.

Choosing `Vanilla` for a behavior means FieldLab does not overwrite that value.

## Defaults

Defaults intentionally reproduce the old test-mod behavior:

- all four tools enabled;
- work efficiency: `50`;
- work durability cost: `0.001`;
- weapon damage: `1000`.

## Design rules

1. Server authority: gameplay components are changed only on the master sim.
2. Minimal interference: disabled or Vanilla settings leave game values untouched.
3. Modular code: configuration and feature implementation are separate modules.
4. No legacy behavior: this project is built from scratch rather than migrated.
5. Diagnostics are opt-in and disabled by default.
