local Config = require("fieldlab/config").Load(modname)
local Tools = require("fieldlab/tools")
local Backpack = require("fieldlab/backpack")

local function GetWorld()
    return GLOBAL.TheWorld
end

Tools.Init(Config, {
    ACTIONS = GLOBAL.ACTIONS,
    GetWorld = GetWorld,
    AddPrefabPostInit = AddPrefabPostInit,
})

Backpack.Init(Config, {
    GetWorld = GetWorld,
    GetTime = GLOBAL.GetTime,
    SEASONS = GLOBAL.SEASONS,
    TUNING = GLOBAL.TUNING,
    SpawnPrefab = GLOBAL.SpawnPrefab,
    AddPrefabPostInit = AddPrefabPostInit,
})
