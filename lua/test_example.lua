-- Run using :so
local Venison = require("venison")
local Input = require("venison.input")
local Draw = require("venison.loop")

local window = Venison.window

local function settings()
    window:create({
        size = {
            width = 20,
            height = 20,
        },
        title = "Test Example",
    }, {})
end

local function setup()
    window.win:map("n", "p", Draw.loop_toggle, { noremap = true })

    window.win:map("n", "q", function()
        window:close()
    end, { noremap = true })

    window.win:map("n", "Q", function()
        window:destroy()
    end, { noremap = true })

    window.win:map("n", "a", function()
        local pos = vim.api.nvim_win_get_cursor(0)
        Input.win_write_text(window, {
            start_line = pos[1] - 1,
            start_col = pos[2] - 1,
            contents = { "hello", "world" },
        })
    end, { noremap = true })
end

local count = 0

local function draw()
    count = count + 1
    Input.win_write_text(window, {
        start_line = 10,
        start_col = 10,
        contents = {
            string.format("%d", count),
        },
    })
end

vim.api.nvim_create_user_command("VL", function()
    window:open()
end, {})

Venison.main(settings, setup, draw)
