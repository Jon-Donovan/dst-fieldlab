local M = {}

function M.Load(modname)
    assert(modname ~= nil, "DST FieldLab: modname is required to load configuration")

    local function read(name, fallback)
        -- GetModConfigData can infer the current mod only when it is called
        -- directly from modmain.lua/modworldgenmain.lua. This module is loaded
        -- with require(), so the owning mod must be supplied explicitly.
        local value = GetModConfigData(name, modname)
        if value == nil then
            return fallback
        end
        return value
    end

    local Config = {}

    Config.debug_logging = read("debug_logging", false)

    Config.tools = {
        enabled = read("tools_enabled", true),
        prefabs = {
            axe = read("tools_axe_enabled", true),
            pickaxe = read("tools_pickaxe_enabled", true),
            shovel = read("tools_shovel_enabled", true),
            hammer = read("tools_hammer_enabled", true),
        },
        work_power = read("tools_work_power", false),
        durability_multiplier = read("tools_durability_multiplier", false),
        weapon_damage = read("tools_weapon_damage", false),
    }

    Config.backpack = {
        enabled = read("backpack_enabled", true),

        core = {
            armor = read("backpack_armor", false),
            armor_durability = read("backpack_armor_durability", false),
            waterproof = read("backpack_waterproof", false),
            light_radius = read("backpack_light", false),
            light_when_dropped = read("backpack_light_when_dropped", false),
            speed_multiplier = read("backpack_speed", false),
        },

        protection = {
            fire = read("backpack_fire_protection", false),
            prevent_burning = read("backpack_prevent_burning", false),
            lightning = read("backpack_lightning_protection", false),
            spider_neutrality = read("backpack_spider_neutrality", false),
        },

        survival = {
            temperature_mode = read("backpack_temperature_mode", "vanilla"),
            target_temperature = read("backpack_target_temperature", 36),
            health_regen = read("backpack_health_regen", false),
            health_regen_delay = read("backpack_health_regen_delay", 5),
            hunger_mode = read("backpack_hunger_mode", "vanilla"),
            hunger_drain = read("backpack_hunger_drain", 0.50),
            hunger_regen = read("backpack_hunger_regen", 0.50),
            hunger_lock = read("backpack_hunger_lock", 1.00),
            sanity_mode = read("backpack_sanity_mode", "vanilla"),
            sanity_regen_per_minute = read("backpack_sanity_regen", 6),
            sanity_lock = read("backpack_sanity_lock", 1.00),
        },
    }

    return Config
end

return M
