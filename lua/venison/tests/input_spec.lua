local Venison = require("venison")
local Input = require("venison.input")

describe("Input should", function()
    before_each(function()
        vim.cmd("silent only!")
        vim.cmd("silent enew!")
    end)

    it("modify window contents", function()
        local window = Venison.window

        window:create({
            size = {
                width = 20,
                height = 20,
            },
        }, {})

        Input.win_write_text(window, {
            start_line = 10,
            start_col = 10,
            contents = { "hello", "world" },
        })

        local bufnr = window.win.bufnr
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)

        assert.are.same(lines[10], "          hello     ")
        assert.are.same(lines[11], "          world     ")
    end)
end)
