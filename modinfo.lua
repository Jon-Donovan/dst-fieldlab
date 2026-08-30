name = "DST FieldLab"
description = "Configurable field laboratory for testing and studying Don't Starve Together gameplay mechanics."
author = "ClTech"
version = "0.2.1"

api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

-- Gameplay changes are server-authoritative; backpack light uses a built-in networked light prefab.
all_clients_require_mod = false
client_only_mod = false

server_filter_tags = {
    "DST FieldLab",
    "testing",
    "tools",
    "backpack",
}

local function bool_options(enabled_hover, disabled_hover)
    return {
        { description = "Enabled",  data = true,  hover = enabled_hover },
        { description = "Disabled", data = false, hover = disabled_hover },
    }
end

local function yes_no_options(yes_hover, no_hover)
    return {
        { description = "Yes", data = true, hover = yes_hover },
        { description = "No",  data = false, hover = no_hover },
    }
end

local function separator(id, label)
    return {
        name = "fieldlab_separator_" .. id,
        label = label,
        options = {
            { description = "", data = 0 },
        },
        default = 0,
    }
end

configuration_options = {
    separator("tools", "TOOLS V2"),

    {
        name = "tools_enabled",
        label = "Tools: Master Switch",
        hover = "Enable or disable all DST FieldLab tool modifications.",
        options = bool_options(
            "Apply configured FieldLab behavior to enabled tools.",
            "Leave all vanilla tools unchanged."
        ),
        default = true,
    },

    separator("tools_targets", "TOOLS TO MODIFY"),

    {
        name = "tools_axe_enabled",
        label = "Axe",
        hover = "Modify the standard Axe prefab.",
        options = bool_options("Modify Axe.", "Keep Axe vanilla."),
        default = true,
    },
    {
        name = "tools_pickaxe_enabled",
        label = "Pickaxe",
        hover = "Modify the standard Pickaxe prefab.",
        options = bool_options("Modify Pickaxe.", "Keep Pickaxe vanilla."),
        default = true,
    },
    {
        name = "tools_shovel_enabled",
        label = "Shovel",
        hover = "Modify the standard Shovel prefab.",
        options = bool_options("Modify Shovel.", "Keep Shovel vanilla."),
        default = true,
    },
    {
        name = "tools_hammer_enabled",
        label = "Hammer",
        hover = "Modify the standard Hammer prefab.",
        options = bool_options("Modify Hammer.", "Keep Hammer vanilla."),
        default = true,
    },

    separator("tools_behavior", "TOOL BEHAVIOR"),

    {
        name = "tools_work_power",
        label = "Work Power",
        hover = "Work units applied per CHOP / MINE / DIG / HAMMER action.",
        options = {
            { description = "Vanilla", data = false, hover = "Do not change work power." },
            { description = "2",       data = 2 },
            { description = "5",       data = 5 },
            { description = "10",      data = 10 },
            { description = "20",      data = 20 },
            { description = "50",      data = 50 },
            { description = "100",     data = 100 },
        },
        default = false,
    },
    {
        name = "tools_durability_multiplier",
        label = "Tool Durability",
        hover = "Increase durability for work actions without changing combat wear.",
        options = {
            { description = "Vanilla",  data = false,      hover = "Keep the original work-action durability cost." },
            { description = "x2",       data = 2 },
            { description = "x5",       data = 5 },
            { description = "x10",      data = 10 },
            { description = "x100",     data = 100 },
            { description = "x1000",    data = 1000 },
            { description = "Infinite", data = "infinite", hover = "Work actions do not consume durability." },
        },
        default = false,
    },
    {
        name = "tools_weapon_damage",
        label = "Weapon Damage",
        hover = "Absolute damage dealt when the modified tool is used as a weapon.",
        options = {
            { description = "Vanilla", data = false, hover = "Keep each tool's original weapon damage." },
            { description = "34",      data = 34 },
            { description = "50",      data = 50 },
            { description = "100",     data = 100 },
            { description = "200",     data = 200 },
            { description = "500",     data = 500 },
            { description = "1000",    data = 1000 },
        },
        default = false,
    },

    separator("backpack_core", "BACKPACK CORE"),

    {
        name = "backpack_enabled",
        label = "Backpack: Master Switch",
        hover = "Enable or disable all standard-backpack FieldLab modules.",
        options = bool_options("Enable configured backpack modules.", "Keep the standard backpack fully vanilla."),
        default = true,
    },
    {
        name = "backpack_armor",
        label = "Armor",
        hover = "Damage absorption while the standard backpack is equipped.",
        options = {
            { description = "Vanilla", data = false },
            { description = "25%", data = 0.25 },
            { description = "50%", data = 0.50 },
            { description = "75%", data = 0.75 },
            { description = "90%", data = 0.90 },
            { description = "95%", data = 0.95 },
            { description = "99%", data = 0.99 },
            { description = "100%", data = 1.00 },
        },
        default = false,
    },
    {
        name = "backpack_armor_durability",
        label = "Armor Durability",
        hover = "Durability of FieldLab armor. If Armor is enabled and this remains Vanilla, 5000 is used as the FieldLab baseline.",
        options = {
            { description = "Vanilla",  data = false, hover = "Use FieldLab baseline 5000 when Armor is enabled." },
            { description = "500",      data = 500 },
            { description = "1000",     data = 1000 },
            { description = "2500",     data = 2500 },
            { description = "5000",     data = 5000 },
            { description = "10000",    data = 10000 },
            { description = "Infinite", data = "infinite" },
        },
        default = false,
    },
    {
        name = "backpack_waterproof",
        label = "Water Protection",
        hover = "Wetness protection while the backpack is equipped.",
        options = {
            { description = "Vanilla", data = false },
            { description = "25%", data = 0.25 },
            { description = "50%", data = 0.50 },
            { description = "75%", data = 0.75 },
            { description = "90%", data = 0.90 },
            { description = "100%", data = 1.00 },
        },
        default = false,
    },
    {
        name = "backpack_light",
        label = "Backpack Light",
        hover = "Light radius emitted by the standard backpack.",
        options = {
            { description = "Off",    data = false },
            { description = "Small",  data = 2 },
            { description = "Medium", data = 4 },
            { description = "Large",  data = 6 },
            { description = "Huge",   data = 8 },
        },
        default = false,
    },
    {
        name = "backpack_light_when_dropped",
        label = "Light When Dropped",
        hover = "Keep backpack light enabled while it is lying on the ground.",
        options = yes_no_options("Light the ground around a dropped backpack.", "Only emit light while equipped."),
        default = false,
    },
    {
        name = "backpack_speed",
        label = "Movement Speed",
        hover = "External movement-speed multiplier while equipped.",
        options = {
            { description = "Vanilla", data = false },
            { description = "+10%", data = 1.10 },
            { description = "+25%", data = 1.25 },
            { description = "+50%", data = 1.50 },
            { description = "+100%", data = 2.00 },
        },
        default = false,
    },

    separator("backpack_protection", "BACKPACK PROTECTION"),

    {
        name = "backpack_fire_protection",
        label = "Fire Damage Protection",
        hover = "Reduce fire damage while equipped.",
        options = {
            { description = "Vanilla", data = false },
            { description = "25%", data = 0.25 },
            { description = "50%", data = 0.50 },
            { description = "75%", data = 0.75 },
            { description = "90%", data = 0.90 },
            { description = "100%", data = 1.00 },
        },
        default = false,
    },
    {
        name = "backpack_prevent_burning",
        label = "Prevent Burning",
        hover = "Immediately extinguish the wearer if the character catches fire.",
        options = yes_no_options("Extinguish character burning while equipped.", "Use vanilla burning behavior."),
        default = false,
    },
    {
        name = "backpack_lightning_protection",
        label = "Lightning Protection",
        hover = "Protection from electric/lightning damage. 100% uses DST insulation; 50% restores half of resolved electric damage.",
        options = {
            { description = "Vanilla", data = false },
            { description = "50%", data = 0.50 },
            { description = "100%", data = 1.00 },
        },
        default = false,
    },
    {
        name = "backpack_spider_neutrality",
        label = "Spider Neutrality",
        hover = "Use the spider disguise tag while equipped. This does not forcibly cancel an existing combat target.",
        options = yes_no_options("Enable spider disguise while equipped.", "Use vanilla spider targeting."),
        default = false,
    },

    separator("backpack_survival", "BACKPACK SURVIVAL"),

    {
        name = "backpack_temperature_mode",
        label = "Temperature Protection",
        hover = "Choose how FieldLab controls wearer temperature.",
        options = {
            { description = "Vanilla",    data = "vanilla" },
            { description = "Insulation", data = "insulation", hover = "Add strong winter and summer insulation." },
            { description = "Stabilize",  data = "stabilize",  hover = "Intervene outside the 10-60 C safe band and move toward target temperature." },
            { description = "Lock",       data = "lock",       hover = "Continuously hold target temperature." },
        },
        default = "vanilla",
    },
    {
        name = "backpack_target_temperature",
        label = "Target Temperature",
        hover = "Used by Stabilize and Lock modes.",
        options = {
            { description = "20 C", data = 20 },
            { description = "25 C", data = 25 },
            { description = "30 C", data = 30 },
            { description = "36 C", data = 36 },
        },
        default = 36,
    },
    {
        name = "backpack_health_regen",
        label = "Health Regeneration",
        hover = "Health restored per second while equipped.",
        options = {
            { description = "Vanilla", data = false },
            { description = "+0.25 HP/sec", data = 0.25 },
            { description = "+0.5 HP/sec",  data = 0.50 },
            { description = "+1 HP/sec",    data = 1.00 },
            { description = "+2 HP/sec",    data = 2.00 },
            { description = "+5 HP/sec",    data = 5.00 },
        },
        default = false,
    },
    {
        name = "backpack_health_regen_delay",
        label = "Regen After Damage",
        hover = "Delay before health regeneration resumes after an attack.",
        options = {
            { description = "Immediately", data = 0 },
            { description = "3 sec", data = 3 },
            { description = "5 sec", data = 5 },
            { description = "10 sec", data = 10 },
        },
        default = 5,
    },
    {
        name = "backpack_hunger_mode",
        label = "Hunger Mode",
        hover = "Choose how FieldLab controls hunger while equipped.",
        options = {
            { description = "Vanilla",       data = "vanilla" },
            { description = "Reduced Drain", data = "reduced" },
            { description = "Regeneration",  data = "regen" },
            { description = "Lock",          data = "lock" },
        },
        default = "vanilla",
    },
    {
        name = "backpack_hunger_drain",
        label = "Hunger Drain",
        hover = "Used by Reduced Drain mode. Percentage of vanilla drain rate.",
        options = {
            { description = "75%", data = 0.75 },
            { description = "50%", data = 0.50 },
            { description = "25%", data = 0.25 },
            { description = "Disabled", data = 0.00 },
        },
        default = 0.50,
    },
    {
        name = "backpack_hunger_regen",
        label = "Hunger Regeneration",
        hover = "Used by Regeneration mode.",
        options = {
            { description = "+0.1/sec",  data = 0.10 },
            { description = "+0.25/sec", data = 0.25 },
            { description = "+0.5/sec",  data = 0.50 },
            { description = "+1/sec",    data = 1.00 },
        },
        default = 0.50,
    },
    {
        name = "backpack_hunger_lock",
        label = "Locked Hunger",
        hover = "Used by Hunger Lock mode.",
        options = {
            { description = "0%", data = 0.00 },
            { description = "25%", data = 0.25 },
            { description = "50%", data = 0.50 },
            { description = "75%", data = 0.75 },
            { description = "100%", data = 1.00 },
        },
        default = 1.00,
    },
    {
        name = "backpack_sanity_mode",
        label = "Sanity Mode",
        hover = "Choose how FieldLab controls sanity while equipped.",
        options = {
            { description = "Vanilla",      data = "vanilla" },
            { description = "Regeneration", data = "regen" },
            { description = "Lock",         data = "lock" },
        },
        default = "vanilla",
    },
    {
        name = "backpack_sanity_regen",
        label = "Sanity Regeneration",
        hover = "Used by Sanity Regeneration mode.",
        options = {
            { description = "+1/min",  data = 1 },
            { description = "+3/min",  data = 3 },
            { description = "+6/min",  data = 6 },
            { description = "+12/min", data = 12 },
            { description = "+30/min", data = 30 },
        },
        default = 6,
    },
    {
        name = "backpack_sanity_lock",
        label = "Locked Sanity",
        hover = "Used by Sanity Lock mode.",
        options = {
            { description = "0%", data = 0.00 },
            { description = "25%", data = 0.25 },
            { description = "50%", data = 0.50 },
            { description = "75%", data = 0.75 },
            { description = "100%", data = 1.00 },
        },
        default = 1.00,
    },

    separator("diagnostics", "DIAGNOSTICS"),

    {
        name = "debug_logging",
        label = "Debug Logging",
        hover = "Write DST FieldLab initialization and lifecycle details to the log.",
        options = {
            { description = "Off", data = false },
            { description = "On",  data = true },
        },
        default = false,
    },
}
