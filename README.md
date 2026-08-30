# DST FieldLab

DST FieldLab is a configurable gameplay laboratory for Don't Starve Together.
Its purpose is to reduce setup friction when studying, reproducing, and testing
specific gameplay mechanics.

## Version 0.2.0 scope

The project currently contains two production-oriented modules:

- **Tools v2** for the standard Axe, Pickaxe, Shovel, and Hammer.
- **Backpack** modules for the standard `backpack` prefab only.

All gameplay defaults are intentionally Vanilla/Off. Installing FieldLab by
itself does not strengthen the player until options are explicitly enabled.

## Tools v2

Each standard tool can be enabled independently. Shared settings control:

- **Work Power:** Vanilla / 2 / 5 / 10 / 20 / 50 / 100.
- **Tool Durability:** Vanilla / x2 / x5 / x10 / x100 / x1000 / Infinite.
- **Weapon Damage:** Vanilla / 34 / 50 / 100 / 200 / 500 / 1000.

Durability multipliers are calculated from each tool's existing work-action
consumption after the vanilla prefab has initialized. Combat durability is not
changed by this option.

## Backpack Core

Applies only to the standard backpack:

- configurable armor absorption;
- configurable armor durability, including indestructible armor;
- water protection;
- configurable light radius;
- optional light while dropped;
- movement-speed multiplier.

When Armor is enabled while Armor Durability remains `Vanilla`, FieldLab uses a
5000-point baseline because the vanilla backpack has no armor durability value
to preserve.

Backpack light is implemented by spawning the game's built-in networked
`minerhatlight` prefab and parenting it to the wearer or dropped backpack. This
keeps light server-authoritative and avoids adding a Light component after the
backpack prefab has already called `SetPristine()`.

## Backpack Protection

- Fire damage reduction: 25% / 50% / 75% / 90% / 100%.
- Prevent Burning: immediately extinguishes character burning while equipped.
- Lightning protection: 50% / 100%.
- Spider Neutrality: temporary `spiderdisguise` tag while equipped.

100% lightning protection uses DST's source-aware external inventory
insulation. DST insulation itself is binary, so the agreed 50% laboratory mode
preserves the electric hit and restores half of the resolved electric health
damage. A lethal electric hit can therefore still kill before restoration; use
100% protection when strict immunity is required.

Spider Neutrality is a disguise, not a global AI override. FieldLab does not
forcibly cancel an existing combat target.

## Backpack Survival

### Temperature

- Vanilla
- Insulation
- Stabilize
- Lock

Insulation adds strong source-aware winter and summer insulation. Stabilize
intervenes only outside the 10-60 C band and moves temperature toward the
configured target by 2 C per second. Lock reapplies the target every 0.5 s.
Target options: 20 / 25 / 30 / 36 C.

### Health

Health regeneration can restore 0.25 / 0.5 / 1 / 2 / 5 HP per second, with an
optional 0 / 3 / 5 / 10 second delay after an attack.

### Hunger

Modes:

- Vanilla
- Reduced Drain (75% / 50% / 25% / Disabled)
- Regeneration (+0.1 / +0.25 / +0.5 / +1 per second)
- Lock (0% / 25% / 50% / 75% / 100%)

Reduced Drain uses the hunger component's source modifier list. Regeneration
uses the component API. Lock uses `SetPercent` instead of modifying internal
fields.

### Sanity

Modes:

- Vanilla
- Regeneration (+1 / +3 / +6 / +12 / +30 per minute)
- Lock (0% / 25% / 50% / 75% / 100%)

## Design rules

1. Gameplay changes execute only on the authoritative master simulation.
2. `Vanilla`/Off means FieldLab does not overwrite the corresponding behavior.
3. Source-aware modifier APIs are used where DST provides them.
4. Original backpack equip/unequip callbacks are wrapped, not replaced.
5. Periodic survival tasks belong to the equipped backpack and are cancelled on unequip/remove.
6. No global creature AI overrides are used.
7. Debug logging is opt-in and disabled by default.

## Modules

```text
scripts/fieldlab/
  config.lua
  tools.lua
  backpack.lua
```


## 0.2.1

- Fixed startup crash: configuration loaded from `scripts/fieldlab/config.lua` now passes the owning mod name explicitly to `GetModConfigData`.


## 0.2.2

- Fixed required-module startup crash: `tools.lua` and `backpack.lua` no longer access the mod-only `GLOBAL`/`AddPrefabPostInit` environment directly. Runtime dependencies are passed explicitly from `modmain.lua`.
