local Popup = require("nui.popup")
local Logger = require("venison.logger")

---@class VenisonWindow
---@field mounted boolean
---@field win nil | NuiPopup
local Window = {
    mounted = false,
    win = nil,
}

---@param self VenisonWindow
function Window:open()
    local pass = Logger:assert(self.win, "venison.window.open(): window is not created")
    if not pass then
        return
    end

    pass = Logger:assert(not self.mounted, "venison.window.open(): window is already open")
    if not pass then
        return
    end

    self.win:show()
    self.mounted = true

    Logger:log("venison.window.open(): window opened")
end

-- Close a window which has been opened (non-destructive)
---@param self VenisonWindow
function Window:close()
    local pass = Logger:assert(self.win, "venison.window.close(): window is not created")
    if not pass then
        return
    end

    pass = Logger:assert(self.mounted, "venison.window.close(): window is not open")
    if not pass then
        return
    end

    self.win:hide()
    self.mounted = false

    Logger:log("venison.window.close(): window closed")
end

-- Destroy a window which has been created
---@param self VenisonWindow
function Window:destroy()
    local pass = Logger:assert(self.win, "venison.window.destroy(): window is not created")
    if not pass then
        return
    end

    if self.mounted then
        Logger:log("venison.window.destroy(): closing open window before destroying")
        self:close()
    end

    self.win:unmount()
    self.win = nil
    self.mounted = false

    Logger:log("venison.window.destroy(): window destroyed")
end

-- Create a window, set up keymaps, and store it in the window object
---@param self VenisonWindow
---@param maps table<string | string[], function | string>
function Window:create(maps)
    local pass = Logger:assert(self.win == nil, "venison.window.create(): window already exists")
    if not pass then
        return
    end

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
            padding = {},
            style = "rounded",
            text = {},
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

    Logger:log("venison.window.create(): window created")

    for keys, mapping in pairs(maps) do
        self.win:map("n", keys, mapping, { noremap = true })
    end

    Logger:log(string.format("venison.window.create(): keymaps set: %s", vim.inspect(maps)))
end

function Window:override(maps)
    local pass = Logger:assert(self.win ~= nil, "venison.window.override(): window does not exist")
    if not pass then
        return
    end

    Logger:log("venison.window.override(): overriding window")

    self.win = nil
    self:create(maps)
end

return Window
