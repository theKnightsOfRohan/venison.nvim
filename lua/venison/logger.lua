-- Credits: partially yoinked from ThePrimeagen/harpoon
local Utils = require("venison.utils")

---@class VenisonLog
---@field lines string[]
---@field max_lines number
---@field enabled boolean
local Logger = {}

Logger.__index = Logger

---@return VenisonLog
function Logger:new()
    local logger = setmetatable({
        lines = {},
        enabled = true,
        max_lines = 50,
    }, self)

    return logger
end

function Logger:disable()
    self.enabled = false
end

function Logger:enable()
    self.enabled = true
end

---@vararg any
function Logger:log(...)
    local processed = {}
    for i = 1, select("#", ...) do
        local item = select(i, ...)
        if type(item) == "table" then
            item = vim.inspect(item)
        end
        table.insert(processed, item)
    end

    local lines = {}
    for _, line in ipairs(processed) do
        local split = Utils.split(line, "\n")
        for _, l in ipairs(split) do
            if not Utils.is_white_space(l) then
                local ll = Utils.trim(Utils.remove_duplicate_whitespace(l))
                table.insert(lines, ll)
            end
        end
    end

    table.insert(self.lines, table.concat(lines, " "))

    while #self.lines > self.max_lines do
        table.remove(self.lines, 1)
    end
end

function Logger:clear()
    self.lines = {}
end

function Logger:show()
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, self.lines)
    vim.api.nvim_win_set_buf(0, bufnr)
end

---@param condition any
---@param message string
---@return boolean success
function Logger:assert(condition, message)
    local success, result = pcall(function()
        assert(condition, string.format("ERROR: %s", message))
    end)
    if not success then
        self:log(result)
    end

    return success
end

return Logger:new()
