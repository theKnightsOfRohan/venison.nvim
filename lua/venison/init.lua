local Popup = require("nui.popup")
local Logger = require("venison.logger")
local Template = require("venison.window")

---@class Venison
---@field timer uv_timer_t
---@field setup function
---@field draw function
local Venison = {}

---@class VenisonWindowMapOpts
---@field mode string
---@field key string|string[]
---@field handler string|function
---@field opts table<string, boolean>
---@field ___force___ any

---@param id string|nil default bufnr
---@param win_opts nui_popup_options
---@param initial_maps VenisonWindowMapOpts[]
---@return VenisonGameWindow
function Venison.create_window(id, win_opts, initial_maps)
    Logger:log("window.create_window(): creating window")

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

    ---@cast Popup VenisonGameWindow
    local win = Popup(passed_opts)
    win.height = passed_opts.size.height
    win.width = passed_opts.size.width
    win.id = id or ("%d"):format(win.bufnr)

    for k, v in pairs(Template) do
        win[k] = v
    end

    for _, map in ipairs(initial_maps) do
        win:map(map.mode, map.key, map.handler, map.opts or {})
    end

    win:fill(" ")

    win.timer = vim.uv.new_timer()

    return win
end

return Venison
