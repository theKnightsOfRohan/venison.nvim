local Utils = require("venison.utils")
local Window = require("venison.window")

describe("Window", function()
    before_each(function()
        vim.cmd("silent only!")
        vim.cmd("silent enew!")
    end)

    it("should successfully be created", function()
        local window = Utils.deepcopy(Window, {})
        assert(window, "Window manager should not be nil")

        window:create({
            ["q"] = function()
                window:close()
            end,
        })

        assert(window.win, "Window pane has not been created successfully")
        assert(not window.mounted, "Window pane should not be opened yet")
    end)

    it("should successfully be opened and closed", function()
        local window = Utils.deepcopy(Window, {})
        assert(window, "Window manager should not be nil")

        window:create({})

        window:open()
        assert(window.mounted, "Window pane has not opened successfully")

        window:close()

        assert(not window.mounted, "Window pane has not closed successfully")
        assert(window.win, "Window pane should not be destroyed")
    end)

    it("should successfully be destroyed", function()
        local window = Utils.deepcopy(Window, {})
        assert(window, "Window manager should not be nil")

        window:create({})
        window:destroy()

        assert(not window.win, "Window has not been destroyed")
    end)

    it("should be able to create custom commands", function()
        local window = Utils.deepcopy(Window, {})
        assert(window, "Window manager should not be nil")

        window:create({
            ["q"] = function()
                window:close()
            end,
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
