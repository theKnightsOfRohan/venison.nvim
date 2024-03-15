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
    -- ah, yes, an extremely efficient game loop
    -- while true do
    draw()
    -- end
end

return Venison
