local Tools = {}

local ACTIONS = GLOBAL.ACTIONS
local TheWorld = GLOBAL.TheWorld

local TOOL_DEFINITIONS = {
    axe = { action = ACTIONS.CHOP, label = "Axe" },
    pickaxe = { action = ACTIONS.MINE, label = "Pickaxe" },
    shovel = { action = ACTIONS.DIG, label = "Shovel" },
    hammer = { action = ACTIONS.HAMMER, label = "Hammer" },
}

local function Log(config, message)
    if config.debug_logging then
        print("[DST FieldLab] " .. message)
    end
end

local function GetVanillaConsumption(finiteuses, action)
    if finiteuses == nil then
        return nil
    end
    if finiteuses.consumption ~= nil and finiteuses.consumption[action] ~= nil then
        return finiteuses.consumption[action]
    end
    return 1
end

local function ApplyToolConfig(inst, definition, config)
    if TheWorld == nil or not TheWorld.ismastersim then
        return
    end

    if config.tools.work_power ~= false then
        if inst.components.tool ~= nil then
            inst.components.tool:SetAction(definition.action, config.tools.work_power)
        else
            Log(config, definition.label .. ": component 'tool' is missing; work power was not applied.")
        end
    end

    if config.tools.durability_multiplier ~= false then
        if inst.components.finiteuses ~= nil then
            local cost = 0
            if config.tools.durability_multiplier ~= "infinite" then
                local vanilla = GetVanillaConsumption(inst.components.finiteuses, definition.action)
                cost = vanilla / config.tools.durability_multiplier
            end
            inst.components.finiteuses:SetConsumption(definition.action, cost)
        else
            Log(config, definition.label .. ": component 'finiteuses' is missing; durability was not applied.")
        end
    end

    if config.tools.weapon_damage ~= false then
        if inst.components.weapon ~= nil then
            inst.components.weapon:SetDamage(config.tools.weapon_damage)
        else
            Log(config, definition.label .. ": component 'weapon' is missing; weapon damage was not applied.")
        end
    end
end

function Tools.Init(config)
    if not config.tools.enabled then
        Log(config, "Tools v2 disabled by master switch.")
        return
    end

    for prefab, definition in pairs(TOOL_DEFINITIONS) do
        if config.tools.prefabs[prefab] then
            AddPrefabPostInit(prefab, function(inst)
                ApplyToolConfig(inst, definition, config)
            end)
            Log(config, "Registered Tools v2 post-init for " .. prefab .. ".")
        else
            Log(config, definition.label .. " left vanilla by configuration.")
        end
    end
end

return Tools
