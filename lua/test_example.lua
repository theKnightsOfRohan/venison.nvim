-- Run using :so
local Venison = require("venison")

local window = Venison.create_window("test", {
    size = {
        width = 40,
        height = 20,
    },
}, {})

local function setup()
    window:map("n", "p", function()
        window:loop_toggle()
    end, { noremap = true })

    window:map("n", "q", function()
        window:close()
    end, { noremap = true })

    window:map("n", "Q", function()
        window:destroy()
    end, { noremap = true })

    window:map("n", "a", function()
        local pos = vim.api.nvim_win_get_cursor(0)
        window:write_text({ "hello", "world" }, pos[1], pos[2])
    end, { noremap = true })

    window.frame_rate = 60
end

local count = 0

local function draw()
    count = count + 1
    window:write_text({ "" .. count }, 20, 10)
end

vim.api.nvim_create_user_command("VW", function()
    window:open()
end, {})

window:main(setup, draw)
