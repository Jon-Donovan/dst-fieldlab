local Tools = {}

local ACTIONS = GLOBAL.ACTIONS
local TheWorld = GLOBAL.TheWorld

local TOOL_DEFINITIONS = {
    axe = {
        action = ACTIONS.CHOP,
        label = "Axe",
    },
    pickaxe = {
        action = ACTIONS.MINE,
        label = "Pickaxe",
    },
    shovel = {
        action = ACTIONS.DIG,
        label = "Shovel",
    },
    hammer = {
        action = ACTIONS.HAMMER,
        label = "Hammer",
    },
}

local function Log(config, message)
    if config.debug_logging then
        print("[DST FieldLab] " .. message)
    end
end

local function ApplyToolConfig(inst, definition, config)
    -- The components modified below exist only on the authoritative simulation.
    if TheWorld == nil or not TheWorld.ismastersim then
        return
    end

    if config.tools.work_efficiency ~= false then
        if inst.components.tool ~= nil then
            inst.components.tool:SetAction(definition.action, config.tools.work_efficiency)
        else
            Log(config, definition.label .. ": component 'tool' is missing; efficiency was not applied.")
        end
    end

    if config.tools.work_durability_cost ~= false then
        if inst.components.finiteuses ~= nil then
            inst.components.finiteuses:SetConsumption(definition.action, config.tools.work_durability_cost)
        else
            Log(config, definition.label .. ": component 'finiteuses' is missing; durability cost was not applied.")
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
