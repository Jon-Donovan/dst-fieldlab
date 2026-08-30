local Config = {}

local function read(name, fallback)
    local value = GetModConfigData(name)
    if value == nil then
        return fallback
    end
    return value
end

Config.debug_logging = read("debug_logging", false)

Config.tools = {
    enabled = read("tools_enabled", true),

    prefabs = {
        axe = read("tools_axe_enabled", true),
        pickaxe = read("tools_pickaxe_enabled", true),
        shovel = read("tools_shovel_enabled", true),
        hammer = read("tools_hammer_enabled", true),
    },

    -- false means "leave the vanilla value untouched".
    work_efficiency = read("tools_work_efficiency", 50),
    work_durability_cost = read("tools_work_durability_cost", 0.001),
    weapon_damage = read("tools_weapon_damage", 1000),
}

return Config
