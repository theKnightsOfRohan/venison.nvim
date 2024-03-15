local Popup = require("nui.popup")

---@class VenisonWindow
---@field mounted boolean
local Window = {
    mounted = false,
}

-- Open a window which has been created
---@param self VenisonWindow
function Window:open()
    assert(self.win, "Window is not created")
    assert(not self.mounted, "Window is already opened")

    self.win:show()
    self.mounted = true
end

-- Close a window which has been opened (non-destructive)
---@param self VenisonWindow
function Window:close()
    assert(self.win, "Window is not created")
    assert(self.mounted, "Window is not opened")

    self.win:hide()
    self.mounted = false
end

-- Destroy a window which has been created
---@param self VenisonWindow
function Window:destroy()
    assert(self.win, "Window is not created")

    if self.mounted then
        self:close()
    end
    self.win:unmount()
    self.win = nil
end

-- Create a window, set up keymaps, and store it in the window object
---@param self VenisonWindow
---@param maps table<string | string[], function | string>
function Window:create(maps)
    assert(not self.win, "Window is already created")

    self.win = Popup({
        position = "50%",
        size = {
            width = 80,
            height = 40,
        },
        enter = true,
        focusable = true,
        zindex = 50,
        relative = "editor",
        border = {
            padding = {
                top = 2,
                bottom = 2,
                left = 3,
                right = 3,
            },
            style = "rounded",
            text = {
                top = " I am top title ",
                top_align = "center",
                bottom = "I am bottom title",
                bottom_align = "left",
            },
        },
        buf_options = {
            modifiable = true,
            readonly = false,
        },
        win_options = {
            winblend = 10,
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
    })

    for keys, mapping in pairs(maps) do
        self.win:map("n", keys, mapping, { noremap = true })
    end
end

return Window
