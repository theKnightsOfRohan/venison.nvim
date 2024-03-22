-- Run using :so
local Venison = require("venison")
local Input = require("venison.input")

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
        {
            mode = "n",
            key = "a",
            handler = function()
                local loc = vim.api.nvim_win_get_cursor(0)
                Input.modify_window_contents(window, {
                    start_line = loc[1] - 2,
                    start_col = loc[2] - 2,
                    contents = {
                        "hello",
                        "world",
                    },
                })
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
