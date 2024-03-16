-- Run using :so
local Venison = require("venison")

local window = Venison.window

local function settings()
    window:create({}, {
        {
            mode = "n",
            key = "q",
            handler = function()
                window:close()
            end,
            opts = { noremap = true },
        },
        {
            mode = "n",
            key = "<S-q>",
            handler = function()
                window:destroy()
            end,
            opts = { noremap = true },
        },
    })
end

local function setup()
    window:open()
end

local function draw() end

Venison.main(settings, setup, draw)
