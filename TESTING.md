# DST FieldLab 0.2.0 test checklist

## Startup / authority

- Start a local hosted world with all options at defaults.
- Start a dedicated server with all options at defaults.
- Confirm there are no Lua errors during world generation/load.
- Confirm vanilla behavior is unchanged with all behavior settings Vanilla/Off.
- With Debug Logging enabled, confirm `[DST FieldLab]` registration/lifecycle messages appear.
- Connect a client without local gameplay configuration changes and verify server behavior is authoritative.

## Tools v2

For Axe, Pickaxe, Shovel, and Hammer:

- Verify each per-tool switch independently.
- Verify Work Power: 2 / 5 / 10 / 20 / 50 / 100.
- Verify Tool Durability multipliers against the original work-action consumption.
- Verify Infinite work durability consumes zero finite uses for CHOP/MINE/DIG/HAMMER.
- Verify combat wear remains vanilla when only Tool Durability is changed.
- Verify Weapon Damage absolute values.
- Verify each Vanilla option leaves the corresponding prefab value untouched.

## Backpack Core

### Armor

- Verify absorption at 25 / 50 / 75 / 90 / 95 / 99 / 100%.
- Verify finite durability: 500 / 1000 / 2500 / 5000 / 10000.
- Verify Armor + Vanilla durability initializes to FieldLab baseline 5000.
- Verify Infinite armor does not lose condition.
- Verify a finite armor backpack remains a backpack when armor reaches zero and no longer absorbs damage.
- Save/reload partially damaged armor and verify condition persistence.

### Water

- Test each water protection percentage in rain and while wetness is increasing.
- Verify Vanilla does not add water protection.

### Light

- Test Small / Medium / Large / Huge radius.
- Verify light follows the wearer while equipped.
- With Light When Dropped = No, verify no light after dropping.
- With Light When Dropped = Yes, verify light follows the backpack on the ground.
- Pick up a lit dropped backpack and verify ground light is removed while merely carried.
- Equip/unequip repeatedly and confirm there is never more than one FieldLab light entity.

### Movement

- Test +10 / +25 / +50 / +100%.
- Combine with Walking Cane/roads/character speed effects.
- Verify unequip restores only FieldLab's multiplier.

## Backpack Protection

### Fire

- Test each fire-damage reduction value.
- Verify 100% fire damage protection does not imply protection from unrelated damage types.
- With Prevent Burning enabled, ignite the character and verify immediate extinguish.
- Verify the backpack item itself still follows its own vanilla burnability rules.

### Lightning / electricity

- Verify 100% mode makes inventory externally insulated and removes only FieldLab's modifier on unequip.
- Verify 50% mode restores half of resolved `electric` damage.
- Verify 50% mode does not restore non-electric damage.
- Document/test lethal electric damage behavior separately: 50% is post-hit restoration, not binary insulation.

### Spider neutrality

- Test normal spiders, spider warriors, cave spiders, spitters, nurses, and other available spider variants.
- Verify neutral spiders do not acquire the wearer through ordinary disguise-sensitive targeting.
- Attack a spider and confirm FieldLab does not globally pacify ongoing combat.
- Equip/unequip on Webber and while another spider-disguise source is active.

## Backpack Survival

### Temperature

- Insulation: verify both winter and summer insulation increase while equipped and are removed on unequip.
- Stabilize: set temperature below 10 C and above 60 C and verify movement toward target at approximately 2 C/sec.
- Verify Stabilize does not alter temperature while inside the 10-60 C band.
- Lock: verify 20 / 25 / 30 / 36 C targets.
- Equip/unequip rapidly and verify no temperature task remains after unequip.

### Health

- Test all regeneration rates.
- Test Immediately / 3 / 5 / 10 second post-attack delays.
- Verify regeneration stops on unequip and does not revive a dead character.

### Hunger

- Reduced Drain: verify 75 / 50 / 25 / 0% burn-rate modifiers.
- Regeneration: verify all configured rates and max clamping.
- Lock: verify 0 / 25 / 50 / 75 / 100%.
- Verify mode effects are removed immediately on unequip.

### Sanity

- Regeneration: verify +1 / +3 / +6 / +12 / +30 per minute.
- Lock: verify 0 / 25 / 50 / 75 / 100%.
- Verify shadow/insanity behavior at low locked values as expected by vanilla mechanics.
- Verify mode effects are removed immediately on unequip.

## Lifecycle / persistence

- Save and reload while backpack is equipped.
- Save and reload while backpack is on the ground with Light When Dropped enabled.
- Enter caves and return to surface.
- Disconnect/reconnect while backpack is equipped.
- Die with backpack equipped and verify all owner effects are removed.
- Respawn and equip again.
- Swap between two standard backpacks repeatedly.
- Burn/remove an equipped backpack and verify tasks/modifiers/light are cleaned up.

## Compatibility sanity checks

- Test characters with custom temperature/hunger/sanity mechanics.
- Test Webber for spider-tag interaction.
- Test WX-78/electricity mechanics.
- Test with common equipment/inventory mods used on the target server.
- Verify no FieldLab modifier remains after unequip when another mod also changes speed, hunger burn rate, fire damage, insulation, or electrical insulation.

## Prevent Burning regression

1. Enable `Prevent Burning`.
2. Equip the standard backpack.
3. Enter an active fire source and verify the character does not enter the burning state.
4. Remove the backpack and verify vanilla ignition works again.
5. Ignite the character without the backpack, then equip the backpack and verify the existing burning state is extinguished immediately.
6. Repeat with a character that already has `fireimmune`; after unequip, verify FieldLab does not remove the pre-existing tag.

