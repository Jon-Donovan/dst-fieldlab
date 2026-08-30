# Tools v2 test checklist

## Startup

- Start a local hosted world with DST FieldLab enabled.
- Start a dedicated server with the mod enabled.
- Confirm there are no Lua errors during world generation/load.
- With Debug Logging enabled, confirm `[DST FieldLab]` registration messages appear.

## Defaults

For each standard axe, pickaxe, shovel, and hammer:

- Verify the correct work action completes with configured efficiency `50`.
- Verify work durability consumption is `0.001` per relevant work action.
- Verify weapon damage is `1000`.

## Per-tool switches

Disable one tool at a time and verify:

- the disabled tool remains fully vanilla;
- the other enabled tools still receive FieldLab settings.

## Vanilla behavior options

For each shared behavior select `Vanilla` and verify FieldLab does not overwrite it:

- Work Efficiency;
- Work Durability Cost;
- Weapon Damage.

## No-work-wear mode

Set Work Durability Cost to `0` and verify CHOP/MINE/DIG/HAMMER work actions do not reduce finite uses.
Also verify combat durability behavior separately; Tools v2 intentionally configures work-action consumption, not combat consumption.

## Persistence / lifecycle

- Save and reload the world; settings must still apply to newly loaded/existing standard tools.
- Enter caves and return to the surface.
- Test after death/respawn.
- Test tools created before save and newly crafted tools.

## Compatibility sanity checks

- Test a character with tool-related bonuses.
- Test with a common inventory/equipment mod if used on the target server.
- Confirm no client-side Lua error occurs when clients do not have DST FieldLab installed.
