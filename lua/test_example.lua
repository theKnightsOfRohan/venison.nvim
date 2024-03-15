-- Run using :so
local Venison = require("venison")

local window = Venison.window

local function settings()
    if not window.win then
        window:create({
            ["q"] = function()
                window:close()
            end,
        })
    end
end

local function setup()
    if not window.mounted then
        window:open()
    end
end

local function draw() end

Venison.main(settings, setup, draw)
