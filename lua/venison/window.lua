local Popup = require("nui.popup")
local Logger = require("venison.logger")

---@class VenisonPopup:NuiPopup
---@field height number
---@field width number

---@class VenisonWindow
---@field mounted boolean
---@field win nil | VenisonPopup
local Window = {
    mounted = false,
    win = nil,
}

---@param self VenisonWindow
function Window:open()
    local pass = Logger:assert(self.win, "window.open(): window is not created")
    if not pass then
        return
    end

    pass = Logger:assert(not self.mounted, "window.open(): window is already open")
    if not pass then
        return
    end

    self.win:show()
    self.mounted = true

    Logger:log("window.open(): window opened")
end

-- Close a window which has been opened (non-destructive)
---@param self VenisonWindow
function Window:close()
    local pass = Logger:assert(self.win, "window.close(): window is not created")
    if not pass then
        return
    end

    pass = Logger:assert(self.mounted, "window.close(): window is not open")
    if not pass then
        return
    end

    self.win:hide()
    self.mounted = false

    Logger:log("window.close(): window closed")
end

-- Destroy a window which has been created
---@param self VenisonWindow
function Window:destroy()
    local pass = Logger:assert(self.win, "window.destroy(): window is not created")
    if not pass then
        return
    end

    if self.mounted then
        Logger:log("window.destroy(): closing open window before destroying")
        self:close()
    end

    self.win:unmount()
    self.win = nil
    self.mounted = false

    Logger:log("window.destroy(): window destroyed")
end

function Window:populate_empty_window()
    local pass = Logger:assert(self.win, "window.populate_empty_window(): window is not created")
    if not pass then
        return
    end

    local contents = {}

    for _ = 1, self.win.height do
        table.insert(contents, string.rep(" ", self.win.width))
    end

    local bufnr = self.win.bufnr
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)
end

---@param maps VenisonWindowMapOpts[]
function Window:set_keymaps(maps)
    local pass = Logger:assert(maps, "window.set_keymaps(): no keymaps provided")
    if not pass then
        return
    end

    for _, map in ipairs(maps) do
        local mode = map.mode
        local key = map.key
        local handler = map.handler
        local opts = map.opts or {}

        self.win:map(mode, key, handler, opts)
    end
end

---@class VenisonWindowMapOpts
---@field mode string
---@field key string|string[]
---@field handler string|function
---@field opts table<string, boolean>
---@field ___force___ any

-- Create a window, set up keymaps, and store it in the window object
---@param self VenisonWindow
---@param win_opts nui_popup_options
---@param maps VenisonWindowMapOpts[]
function Window:create(win_opts, maps)
    local pass = Logger:assert(self.win == nil, "window.create(): window already exists")
    if not pass then
        return
    end

    local passed_opts = vim.tbl_deep_extend("force", {
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
            modifiable = false,
            readonly = false,
        },
        win_options = {
            winblend = 10,
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
    }, win_opts or {})

    ---@cast Popup VenisonPopup
    self.win = Popup(passed_opts)
    self.win.height = passed_opts.size.height
    self.win.width = passed_opts.size.width

    Logger:log("window.create(): window created")

    self:set_keymaps(maps)

    self:populate_empty_window()

    Logger:log(string.format("window.create(): keymaps set: %s", vim.inspect(maps)))
end

---@param self VenisonWindow
---@param win_opts nui_popup_options
---@param maps VenisonWindowMapOpts[]
function Window:override(win_opts, maps)
    local pass = Logger:assert(self.win ~= nil, "window.override(): window does not exist")
    if not pass then
        return
    end

    Logger:log("window.override(): overriding window")

    self.win = nil
    self:create(win_opts, maps)
end

return Window
