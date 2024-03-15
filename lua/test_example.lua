-- Run using :so
local Venison = require("venison")

local window = Venison.window

local function settings()
    window:create({
        ["q"] = function()
            window:close()
        end,
        ["<S-q>"] = function()
            window:destroy()
        end,
    })
end

local function setup()
    window:open()
end

local function draw() end

Venison.main(settings, setup, draw)
