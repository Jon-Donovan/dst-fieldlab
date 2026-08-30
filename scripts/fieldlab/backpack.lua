local Backpack = {}

local GetWorld
local GetTime
local SEASONS
local TUNING
local SpawnPrefab
local AddPrefabPostInit

local SPEED_KEY = "dst_fieldlab_backpack"
local TEMP_KEY = "dst_fieldlab_backpack"
local DEFAULT_ARMOR_DURABILITY = 5000
local STABILIZE_MIN = 10
local STABILIZE_MAX = 60
local STABILIZE_STEP = 2

local function Log(config, message)
    if config.debug_logging then
        print("[DST FieldLab] " .. message)
    end
end

local function CancelTask(inst, key)
    local task = inst[key]
    if task ~= nil then
        task:Cancel()
        inst[key] = nil
    end
end

local function RemoveLight(inst)
    if inst._fieldlab_light ~= nil then
        if inst._fieldlab_light:IsValid() then
            inst._fieldlab_light:Remove()
        end
        inst._fieldlab_light = nil
    end
end

local function EnsureLight(inst, parent, config)
    local radius = config.backpack.core.light_radius
    if radius == false or parent == nil or not parent:IsValid() then
        RemoveLight(inst)
        return
    end

    if inst._fieldlab_light == nil or not inst._fieldlab_light:IsValid() then
        inst._fieldlab_light = SpawnPrefab("minerhatlight")
    end

    local light = inst._fieldlab_light
    if light == nil then
        return
    end

    if light.Light ~= nil then
        light.Light:SetFalloff(0.7)
        light.Light:SetIntensity(0.8)
        light.Light:SetRadius(radius)
        light.Light:SetColour(1, 1, 0.8)
        light.Light:Enable(true)
    end
    light.entity:SetParent(parent.entity)
end

local function IsEquipped(inst)
    return inst.components ~= nil
        and inst.components.equippable ~= nil
        and inst.components.equippable:IsEquipped()
end

local function RefreshLight(inst, config)
    if config.backpack.core.light_radius == false then
        RemoveLight(inst)
        return
    end

    if IsEquipped(inst) then
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        EnsureLight(inst, owner, config)
        return
    end

    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
    if config.backpack.core.light_when_dropped and owner == nil and not inst:IsInLimbo() then
        EnsureLight(inst, inst, config)
    else
        RemoveLight(inst)
    end
end

local function ApplySpeed(inst, owner, config)
    local multiplier = config.backpack.core.speed_multiplier
    if multiplier ~= false and owner.components.locomotor ~= nil then
        owner.components.locomotor:SetExternalSpeedMultiplier(inst, SPEED_KEY, multiplier)
    end
end

local function RemoveSpeed(inst, owner)
    if owner.components.locomotor ~= nil then
        owner.components.locomotor:RemoveExternalSpeedMultiplier(inst, SPEED_KEY)
    end
end

local function ApplyFireProtection(inst, owner, config)
    local protection = config.backpack.protection.fire
    if protection ~= false
        and owner.components.health ~= nil
        and owner.components.health.externalfiredamagemultipliers ~= nil then
        owner.components.health.externalfiredamagemultipliers:SetModifier(inst, math.max(0, 1 - protection))
    end
end

local function RemoveFireProtection(inst, owner)
    if owner.components.health ~= nil
        and owner.components.health.externalfiredamagemultipliers ~= nil then
        owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
    end
end

local function ApplyPreventBurning(inst, owner, config)
    if not config.backpack.protection.prevent_burning then
        return
    end

    inst._fieldlab_on_owner_ignite = function()
        if owner.components.burnable ~= nil and owner.components.burnable:IsBurning() then
            owner.components.burnable:Extinguish()
        end
    end
    inst:ListenForEvent("onignite", inst._fieldlab_on_owner_ignite, owner)

    if owner.components.burnable ~= nil and owner.components.burnable:IsBurning() then
        owner.components.burnable:Extinguish()
    end
end

local function RemovePreventBurning(inst, owner)
    if inst._fieldlab_on_owner_ignite ~= nil then
        inst:RemoveEventCallback("onignite", inst._fieldlab_on_owner_ignite, owner)
        inst._fieldlab_on_owner_ignite = nil
    end
end

local function ApplyLightningProtection(inst, owner, config)
    local protection = config.backpack.protection.lightning
    if protection == false then
        return
    end

    if protection >= 1 then
        if owner.components.inventory ~= nil
            and owner.components.inventory.isexternallyinsulated ~= nil then
            owner.components.inventory.isexternallyinsulated:SetModifier(inst, true)
        end
        return
    end

    -- DST electricity insulation is binary. For the agreed 50% laboratory mode,
    -- restore half of resolved electric damage after the hit. This preserves
    -- electric hit events while reducing the effective health loss.
    inst._fieldlab_on_electric_attacked = function(_, data)
        if data ~= nil
            and data.stimuli == "electric"
            and data.damageresolved ~= nil
            and data.damageresolved > 0
            and owner.components.health ~= nil
            and not owner.components.health:IsDead() then
            owner.components.health:DoDelta(data.damageresolved * protection, false, "dst_fieldlab_lightning")
        end
    end
    inst:ListenForEvent("attacked", inst._fieldlab_on_electric_attacked, owner)
end

local function RemoveLightningProtection(inst, owner)
    if owner.components.inventory ~= nil
        and owner.components.inventory.isexternallyinsulated ~= nil then
        owner.components.inventory.isexternallyinsulated:RemoveModifier(inst)
    end

    if inst._fieldlab_on_electric_attacked ~= nil then
        inst:RemoveEventCallback("attacked", inst._fieldlab_on_electric_attacked, owner)
        inst._fieldlab_on_electric_attacked = nil
    end
end

local function ApplySpiderNeutrality(inst, owner, config)
    if not config.backpack.protection.spider_neutrality then
        return
    end

    inst._fieldlab_owner_had_spiderdisguise = owner:HasTag("spiderdisguise")
    owner:AddTag("spiderdisguise")
end

local function RemoveSpiderNeutrality(inst, owner)
    if inst._fieldlab_owner_had_spiderdisguise == false then
        owner:RemoveTag("spiderdisguise")
    end
    inst._fieldlab_owner_had_spiderdisguise = nil
end

local function ApplyTemperature(inst, owner, config)
    local mode = config.backpack.survival.temperature_mode
    local temperature = owner.components.temperature
    if temperature == nil or mode == "vanilla" then
        return
    end

    if mode == "insulation" then
        local insulation = TUNING.INSULATION_LARGE or 240
        if temperature.SetInsulationModifier ~= nil then
            temperature:SetInsulationModifier(SEASONS.WINTER, inst, insulation, TEMP_KEY)
            temperature:SetInsulationModifier(SEASONS.SUMMER, inst, insulation, TEMP_KEY)
        end
        return
    end

    local target = config.backpack.survival.target_temperature
    if mode == "lock" then
        inst._fieldlab_temperature_task = inst:DoPeriodicTask(0.5, function()
            if owner:IsValid() and owner.components.temperature ~= nil then
                owner.components.temperature:SetTemperature(target)
            end
        end, 0)
    elseif mode == "stabilize" then
        inst._fieldlab_temperature_task = inst:DoPeriodicTask(1, function()
            if not owner:IsValid() or owner.components.temperature == nil then
                return
            end
            local current = owner.components.temperature:GetCurrent()
            if current < STABILIZE_MIN then
                owner.components.temperature:SetTemperature(math.min(target, current + STABILIZE_STEP))
            elseif current > STABILIZE_MAX then
                owner.components.temperature:SetTemperature(math.max(target, current - STABILIZE_STEP))
            end
        end, 0)
    end
end

local function RemoveTemperature(inst, owner)
    CancelTask(inst, "_fieldlab_temperature_task")
    if owner.components.temperature ~= nil
        and owner.components.temperature.RemoveInsulationModifier ~= nil then
        owner.components.temperature:RemoveInsulationModifier(SEASONS.WINTER, inst, TEMP_KEY)
        owner.components.temperature:RemoveInsulationModifier(SEASONS.SUMMER, inst, TEMP_KEY)
    end
end

local function ApplyHealthRegen(inst, owner, config)
    local rate = config.backpack.survival.health_regen
    if rate == false or owner.components.health == nil then
        return
    end

    inst._fieldlab_last_attacked_time = nil
    inst._fieldlab_on_healthdelta_for_regen = function(_, data)
        if data ~= nil and data.amount ~= nil and data.amount < 0 then
            inst._fieldlab_last_attacked_time = GetTime()
        end
    end
    inst:ListenForEvent("healthdelta", inst._fieldlab_on_healthdelta_for_regen, owner)

    local delay = config.backpack.survival.health_regen_delay or 0
    inst._fieldlab_health_task = inst:DoPeriodicTask(1, function()
        if not owner:IsValid() or owner.components.health == nil or owner.components.health:IsDead() then
            return
        end
        local last = inst._fieldlab_last_attacked_time
        if last == nil or GetTime() - last >= delay then
            owner.components.health:DoDelta(rate, true, "dst_fieldlab_health_regen")
        end
    end, 1)
end

local function RemoveHealthRegen(inst, owner)
    CancelTask(inst, "_fieldlab_health_task")
    if inst._fieldlab_on_healthdelta_for_regen ~= nil then
        inst:RemoveEventCallback("healthdelta", inst._fieldlab_on_healthdelta_for_regen, owner)
        inst._fieldlab_on_healthdelta_for_regen = nil
    end
    inst._fieldlab_last_attacked_time = nil
end

local function ApplyHunger(inst, owner, config)
    local hunger = owner.components.hunger
    local mode = config.backpack.survival.hunger_mode
    if hunger == nil or mode == "vanilla" then
        return
    end

    if mode == "reduced" then
        if hunger.burnratemodifiers ~= nil then
            hunger.burnratemodifiers:SetModifier(inst, config.backpack.survival.hunger_drain)
        end
    elseif mode == "regen" then
        local rate = config.backpack.survival.hunger_regen
        inst._fieldlab_hunger_task = inst:DoPeriodicTask(1, function()
            if owner:IsValid() and owner.components.hunger ~= nil then
                owner.components.hunger:DoDelta(rate)
            end
        end, 1)
    elseif mode == "lock" then
        local percent = config.backpack.survival.hunger_lock
        inst._fieldlab_hunger_task = inst:DoPeriodicTask(0.5, function()
            if owner:IsValid() and owner.components.hunger ~= nil then
                owner.components.hunger:SetPercent(percent, false)
            end
        end, 0)
    end
end

local function RemoveHunger(inst, owner)
    CancelTask(inst, "_fieldlab_hunger_task")
    if owner.components.hunger ~= nil
        and owner.components.hunger.burnratemodifiers ~= nil then
        owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end
end

local function ApplySanity(inst, owner, config)
    local sanity = owner.components.sanity
    local mode = config.backpack.survival.sanity_mode
    if sanity == nil or mode == "vanilla" then
        return
    end

    if mode == "regen" then
        local per_second = config.backpack.survival.sanity_regen_per_minute / 60
        inst._fieldlab_sanity_task = inst:DoPeriodicTask(1, function()
            if owner:IsValid() and owner.components.sanity ~= nil then
                owner.components.sanity:DoDelta(per_second)
            end
        end, 1)
    elseif mode == "lock" then
        local percent = config.backpack.survival.sanity_lock
        inst._fieldlab_sanity_task = inst:DoPeriodicTask(0.5, function()
            if owner:IsValid() and owner.components.sanity ~= nil then
                owner.components.sanity:SetPercent(percent)
            end
        end, 0)
    end
end

local function RemoveSanity(inst, owner)
    CancelTask(inst, "_fieldlab_sanity_task")
end

local function ApplyOwnerEffects(inst, owner, config)
    if inst._fieldlab_effect_owner ~= nil and inst._fieldlab_effect_owner ~= owner then
        -- Defensive cleanup for abnormal equip transitions.
        local previous = inst._fieldlab_effect_owner
        if previous:IsValid() then
            RemoveSpeed(inst, previous)
            RemoveFireProtection(inst, previous)
            RemovePreventBurning(inst, previous)
            RemoveLightningProtection(inst, previous)
            RemoveSpiderNeutrality(inst, previous)
            RemoveTemperature(inst, previous)
            RemoveHealthRegen(inst, previous)
            RemoveHunger(inst, previous)
            RemoveSanity(inst, previous)
        end
    end

    inst._fieldlab_effect_owner = owner
    ApplySpeed(inst, owner, config)
    ApplyFireProtection(inst, owner, config)
    ApplyPreventBurning(inst, owner, config)
    ApplyLightningProtection(inst, owner, config)
    ApplySpiderNeutrality(inst, owner, config)
    ApplyTemperature(inst, owner, config)
    ApplyHealthRegen(inst, owner, config)
    ApplyHunger(inst, owner, config)
    ApplySanity(inst, owner, config)

    Log(config, "Backpack effects applied to " .. tostring(owner.prefab or owner) .. ".")
end

local function RemoveOwnerEffects(inst, owner, config)
    owner = owner or inst._fieldlab_effect_owner
    if owner == nil then
        return
    end

    RemoveSpeed(inst, owner)
    RemoveFireProtection(inst, owner)
    RemovePreventBurning(inst, owner)
    RemoveLightningProtection(inst, owner)
    RemoveSpiderNeutrality(inst, owner)
    RemoveTemperature(inst, owner)
    RemoveHealthRegen(inst, owner)
    RemoveHunger(inst, owner)
    RemoveSanity(inst, owner)

    if inst._fieldlab_effect_owner == owner then
        inst._fieldlab_effect_owner = nil
    end
    Log(config, "Backpack effects removed from " .. tostring(owner.prefab or owner) .. ".")
end

local function ConfigureArmor(inst, config)
    local absorb = config.backpack.core.armor
    if absorb == false then
        return
    end

    if inst.components.armor == nil then
        inst:AddComponent("armor")
    end

    local durability = config.backpack.core.armor_durability
    if durability == "infinite" then
        inst.components.armor:InitIndestructible(absorb)
    else
        inst.components.armor:InitCondition(durability or DEFAULT_ARMOR_DURABILITY, absorb)
        inst.components.armor:SetKeepOnFinished(true)
        inst.components.armor:SetOnFinished(function(item)
            if item.components.armor ~= nil then
                item.components.armor:SetAbsorption(0)
            end
        end)
    end
end

local function ConfigureWaterproof(inst, config)
    local effectiveness = config.backpack.core.waterproof
    if effectiveness == false then
        return
    end

    if inst.components.waterproofer == nil then
        inst:AddComponent("waterproofer")
    end
    inst.components.waterproofer:SetEffectiveness(effectiveness)
    inst:AddTag("waterproofer")
end

local function WrapCallbacks(inst, config)
    local equippable = inst.components.equippable
    local inventoryitem = inst.components.inventoryitem

    local vanilla_onequip = equippable.onequipfn
    local vanilla_onunequip = equippable.onunequipfn
    local vanilla_ondrop = inventoryitem.ondropfn
    local vanilla_onputininventory = inventoryitem.onputininventoryfn

    equippable:SetOnEquip(function(item, owner, from_ground)
        if vanilla_onequip ~= nil then
            vanilla_onequip(item, owner, from_ground)
        end
        ApplyOwnerEffects(item, owner, config)
        RefreshLight(item, config)
    end)

    equippable:SetOnUnequip(function(item, owner)
        RemoveOwnerEffects(item, owner, config)
        if vanilla_onunequip ~= nil then
            vanilla_onunequip(item, owner)
        end
        RefreshLight(item, config)
    end)

    inventoryitem:SetOnDroppedFn(function(item)
        if vanilla_ondrop ~= nil then
            vanilla_ondrop(item)
        end
        RefreshLight(item, config)
    end)

    inventoryitem:SetOnPutInInventoryFn(function(item, owner)
        if vanilla_onputininventory ~= nil then
            vanilla_onputininventory(item, owner)
        end
        RefreshLight(item, config)
    end)

    inst:ListenForEvent("onremove", function(item)
        if item._fieldlab_effect_owner ~= nil and item._fieldlab_effect_owner:IsValid() then
            RemoveOwnerEffects(item, item._fieldlab_effect_owner, config)
        end
        RemoveLight(item)
    end)
end

local function BackpackPostInit(inst, config)
    local world = GetWorld()
    if world == nil or not world.ismastersim then
        return
    end

    if inst.components.equippable == nil or inst.components.inventoryitem == nil then
        Log(config, "Backpack is missing equippable/inventoryitem components; FieldLab backpack modules were skipped.")
        return
    end

    ConfigureArmor(inst, config)
    ConfigureWaterproof(inst, config)
    WrapCallbacks(inst, config)
    RefreshLight(inst, config)
end

function Backpack.Init(config, deps)
    assert(deps ~= nil, "DST FieldLab: backpack dependencies are required")
    assert(deps.GetWorld ~= nil, "DST FieldLab: GetWorld dependency is required")
    assert(deps.GetTime ~= nil, "DST FieldLab: GetTime dependency is required")
    assert(deps.SEASONS ~= nil, "DST FieldLab: SEASONS dependency is required")
    assert(deps.TUNING ~= nil, "DST FieldLab: TUNING dependency is required")
    assert(deps.SpawnPrefab ~= nil, "DST FieldLab: SpawnPrefab dependency is required")
    assert(deps.AddPrefabPostInit ~= nil, "DST FieldLab: AddPrefabPostInit dependency is required")

    GetWorld = deps.GetWorld
    GetTime = deps.GetTime
    SEASONS = deps.SEASONS
    TUNING = deps.TUNING
    SpawnPrefab = deps.SpawnPrefab
    AddPrefabPostInit = deps.AddPrefabPostInit

    if not config.backpack.enabled then
        Log(config, "Backpack modules disabled by master switch.")
        return
    end

    AddPrefabPostInit("backpack", function(inst)
        BackpackPostInit(inst, config)
    end)
    Log(config, "Registered backpack post-init.")
end

return Backpack
