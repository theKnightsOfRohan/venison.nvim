-- local Input = require("venison.input")
local Drawer = require("venison.loop")

---@class Venison
---@field window VenisonWindow
local Venison = {
    window = require("venison.window"),
}

---@param settings function Initialize settings and variables
---@param setup function Initialize the game variables
---@param draw function The main game loop
function Venison.main(settings, setup, draw)
    settings()
    setup()
    Drawer.draw(draw)
end

return Venison
