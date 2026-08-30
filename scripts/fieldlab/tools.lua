local Tools = {}

local TOOL_DEFINITIONS = {
    axe = { action_name = "CHOP", label = "Axe" },
    pickaxe = { action_name = "MINE", label = "Pickaxe" },
    shovel = { action_name = "DIG", label = "Shovel" },
    hammer = { action_name = "HAMMER", label = "Hammer" },
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

local function ApplyToolConfig(inst, definition, config, deps)
    local world = deps.GetWorld()
    if world == nil or not world.ismastersim then
        return
    end

    local action = deps.ACTIONS[definition.action_name]
    if action == nil then
        Log(config, definition.label .. ": DST action '" .. definition.action_name .. "' is missing; FieldLab changes were skipped.")
        return
    end

    if config.tools.work_power ~= false then
        if inst.components.tool ~= nil then
            inst.components.tool:SetAction(action, config.tools.work_power)
        else
            Log(config, definition.label .. ": component 'tool' is missing; work power was not applied.")
        end
    end

    if config.tools.durability_multiplier ~= false then
        if inst.components.finiteuses ~= nil then
            local cost = 0
            if config.tools.durability_multiplier ~= "infinite" then
                local vanilla = GetVanillaConsumption(inst.components.finiteuses, action)
                cost = vanilla / config.tools.durability_multiplier
            end
            inst.components.finiteuses:SetConsumption(action, cost)
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

function Tools.Init(config, deps)
    assert(deps ~= nil, "DST FieldLab: tools dependencies are required")
    assert(deps.ACTIONS ~= nil, "DST FieldLab: ACTIONS dependency is required")
    assert(deps.GetWorld ~= nil, "DST FieldLab: GetWorld dependency is required")
    assert(deps.AddPrefabPostInit ~= nil, "DST FieldLab: AddPrefabPostInit dependency is required")

    if not config.tools.enabled then
        Log(config, "Tools v2 disabled by master switch.")
        return
    end

    for prefab, definition in pairs(TOOL_DEFINITIONS) do
        if config.tools.prefabs[prefab] then
            deps.AddPrefabPostInit(prefab, function(inst)
                ApplyToolConfig(inst, definition, config, deps)
            end)
            Log(config, "Registered Tools v2 post-init for " .. prefab .. ".")
        else
            Log(config, definition.label .. " left vanilla by configuration.")
        end
    end
end

return Tools
