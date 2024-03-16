local Utils = require("venison.utils")
local Window = require("venison.window")

describe("Window", function()
    before_each(function()
        vim.cmd("silent only!")
        vim.cmd("silent enew!")
    end)

    it("should successfully be created", function()
        local window = Utils.deepcopy(Window, {})
        assert(window, "Window should not be nil")

        window:create({}, {})

        assert(window.win, "Window pane has not been created successfully")
        assert(not window.mounted, "Window pane should not be opened yet")
    end)

    it("should successfully be opened and closed", function()
        local window = Utils.deepcopy(Window, {})
        assert(window, "Window should not be nil")

        window:create({})

        window:open()
        assert(window.mounted, "Window pane has not opened successfully")

        window:close()

        assert(not window.mounted, "Window pane has not closed successfully")
        assert(window.win, "Window pane should not be destroyed")
    end)

    it("should successfully be destroyed", function()
        local window = Utils.deepcopy(Window, {})
        assert(window, "Window should not be nil")

        window:create({})
        window:destroy()

        assert(not window.win, "Window has not been destroyed")
    end)

    it("should be able to modify default settings", function()
        local window = Utils.deepcopy(Window, {})
        assert(window, "Window should not be nil")

        window:create({
            size = {
                width = 40,
                height = 20,
            },
        }, {})

        assert(window.win, "Window pane has not been created successfully")
        window:open()

        assert(window.mounted, "Window pane has not opened successfully")
        local shown_size = {
            width = vim.api.nvim_win_get_width(0),
            height = vim.api.nvim_win_get_height(0),
        }

        assert.are.same({ width = 40, height = 20 }, shown_size, "Window size has not been set correctly")
        window:destroy()
    end)

    it("should be able to create custom commands", function()
        local window = Utils.deepcopy(Window, {})
        assert(window, "Window should not be nil")

        window:create({}, {
            {
                mode = "n",
                key = "q",
                handler = function()
                    window:close()
                end,
                opts = {},
            },
        })

        assert(window.win, "Window pane has not been created successfully")
        assert(not window.mounted, "Window pane should not be opened yet")

        window:open()
        assert(window.mounted, "Window pane has not opened successfully")

        vim.cmd("normal q")
        assert(not window.mounted, "Window pane has not closed successfully")
        assert(window.win, "Window pane should not be destroyed")
    end)
end)
