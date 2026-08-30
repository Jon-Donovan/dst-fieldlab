local Config = require("fieldlab/config").Load(modname)
local Tools = require("fieldlab/tools")
local Backpack = require("fieldlab/backpack")

Tools.Init(Config)
Backpack.Init(Config)
