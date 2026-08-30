name = "DST FieldLab"
description = "Configurable field laboratory for testing and studying Don't Starve Together gameplay mechanics."
author = "ClTech"
version = "0.1.0"

api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

-- Tools v2 contains server-side gameplay changes only.
-- Clients do not need to download the mod for this phase.
all_clients_require_mod = false
client_only_mod = false

server_filter_tags = {
    "DST FieldLab",
    "testing",
    "tools",
}

local function bool_options(enabled_hover, disabled_hover)
    return {
        { description = "Enabled",  data = true,  hover = enabled_hover },
        { description = "Disabled", data = false, hover = disabled_hover },
    }
end

local function separator(label)
    return {
        name = "fieldlab_separator_" .. label,
        label = label,
        options = {
            { description = "", data = 0 },
        },
        default = 0,
    }
end

configuration_options = {
    separator("TOOLS V2"),

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

    separator("TOOLS TO MODIFY"),

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

    separator("TOOL BEHAVIOR"),

    {
        name = "tools_work_efficiency",
        label = "Work Efficiency",
        hover = "Power applied per CHOP / MINE / DIG / HAMMER action. Vanilla keeps the game's original value.",
        options = {
            { description = "Vanilla", data = false, hover = "Do not change work efficiency." },
            { description = "x2",      data = 2 },
            { description = "x5",      data = 5 },
            { description = "x10",     data = 10 },
            { description = "x20",     data = 20 },
            { description = "x50",     data = 50 },
            { description = "x100",    data = 100 },
        },
        default = 50,
    },
    {
        name = "tools_work_durability_cost",
        label = "Work Durability Cost",
        hover = "Finite-use cost of one tool work action. Vanilla leaves the game's original consumption unchanged.",
        options = {
            { description = "Vanilla",      data = false, hover = "Keep the original work-action durability cost." },
            { description = "1",            data = 1,     hover = "One use per work action." },
            { description = "0.5",          data = 0.5 },
            { description = "0.1",          data = 0.1 },
            { description = "0.01",         data = 0.01 },
            { description = "0.001",        data = 0.001, hover = "Prototype FieldLab behavior." },
            { description = "No work wear", data = 0,     hover = "Work actions do not consume durability." },
        },
        default = 0.001,
    },
    {
        name = "tools_weapon_damage",
        label = "Weapon Damage",
        hover = "Damage dealt when the modified tool is used as a weapon. Vanilla keeps each tool's original damage.",
        options = {
            { description = "Vanilla", data = false, hover = "Keep each tool's original weapon damage." },
            { description = "17",      data = 17 },
            { description = "27.2",    data = 27.2 },
            { description = "34",      data = 34 },
            { description = "42.5",    data = 42.5 },
            { description = "59.5",    data = 59.5 },
            { description = "68",      data = 68 },
            { description = "100",     data = 100 },
            { description = "200",     data = 200 },
            { description = "500",     data = 500 },
            { description = "1000",    data = 1000, hover = "Prototype FieldLab behavior." },
        },
        default = 1000,
    },

    separator("DIAGNOSTICS"),

    {
        name = "debug_logging",
        label = "Debug Logging",
        hover = "Write DST FieldLab initialization details to the server log.",
        options = {
            { description = "Off", data = false },
            { description = "On",  data = true },
        },
        default = false,
    },
}
