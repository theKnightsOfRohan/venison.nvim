local Logger = require("venison.logger")
local Utils = require("venison.utils")

---@class VenisonGameWindow:NuiPopup
---@field mounted boolean
---@field width number
---@field height number
---@field id string
---@field setup function
---@field draw function
---@field timer uv_timer_t
---@field frame_rate number
local Template = {
    frame_rate = 10,
}

function Template:open()
    local pass = Logger:assert(self.bufnr, ("[%s].open(): window is not created"):format(self.id))
    if not pass then
        return
    end

    pass = Logger:assert(not self.mounted, ("[%s].open(): window is already open"):format(self.id))
    if not pass then
        return
    end

    self:show()
    self.mounted = true

    Logger:log(("[%s].open(): window opened"):format(self.id))
end

function Template:close()
    local pass = Logger:assert(self.bufnr, "[%s].close(): window is not created")
    if not pass then
        return
    end

    pass = Logger:assert(self.mounted, "[%s].close(): window is not open")
    if not pass then
        return
    end

    self:hide()
    self.mounted = false

    Logger:log(("[%s].close(): window closed"):format(self.id))
end

function Template:destroy()
    local pass = Logger:assert(self.bufnr, ("[%s].destroy(): window is not created"):format(self.id))
    if not pass then
        return
    end

    if self.mounted then
        Logger:log(("[%s].destroy(): closing open window before destroying"):format(self.id))
        self:close()
    end

    local id = self.id

    self.bufnr = nil
    self.mounted = nil

    Logger:log(("[%s].destroy(): window destroyed"):format(id))
end

---@param lines string[]
---@param start_line number
---@param start_col number
function Template:write_text(lines, start_line, start_col)
    local pass = Logger:assert(self.bufnr, ("[%s].modify_window_contents(): window is not created"):format(self.id))
    if not pass then
        return
    end

    vim.schedule(function()
        vim.api.nvim_buf_set_option(self.bufnr, "modifiable", true)
        vim.api.nvim_buf_set_option(self.bufnr, "readonly", false)

        for i, line in ipairs(lines) do
            local line_num = start_line + i - 1
            pass = Logger:assert(
                line_num <= self.height,
                ("[%s].write_text(): line number of %d exceeds window height of %d"):format(
                    self.bufnr,
                    line_num,
                    self.height
                )
            )
            if not pass then
                break
            end

            pass = Logger:assert(line_num > 0, ("[%s].write_text(): line number of %d < 1"):format(self.id, line_num))
            if not pass then
                goto continue
            end

            local old_line_contents = vim.api.nvim_buf_get_lines(self.bufnr, line_num - 1, line_num, false)[1]

            pass = Logger:assert(
                #old_line_contents == self.width,
                ("[%s].write_text(): line width does not match window width"):format(self.id)
            )
            if not pass then
                break
            end

            local new_line_contents = Utils.intersect_string(old_line_contents, line, start_col + 1)

            pass = Logger:assert(
                new_line_contents ~= old_line_contents,
                ("[%s].write_text(): no change detected"):format(self.id)
            )
            if not pass then
                goto continue
            end

            pass = Logger:assert(
                #new_line_contents == #old_line_contents,
                ("[%s].write_text(): new line width does not match old line width: %d != %d"):format(
                    self.id,
                    #new_line_contents,
                    #old_line_contents
                )
            )
            if not pass then
                break
            end

            vim.api.nvim_buf_set_lines(self.bufnr, line_num - 1, line_num, false, { new_line_contents })

            ::continue::
        end

        vim.api.nvim_buf_set_option(self.bufnr, "modifiable", false)
        vim.api.nvim_buf_set_option(self.bufnr, "readonly", true)

        if not pass then
            Logger:log(("[%s].modify_window_contents(): modifications failed"):format(self.id))
            return
        end

        Logger:log(("[%s].modify_window_contents(): modifications applied"):format(self.id))
    end)
end

---@param char string length 1
function Template:fill(char)
    local pass = Logger:assert(#char == 1, ("[%s].fill(): invalid character '%s' provided"):format(self.id, char))
    if not pass then
        return
    end

    pass = Logger:assert(self.bufnr, ("[%s].fill(): window is not created"):format(self.id))
    if not pass then
        return
    end

    Logger:log(("[%s].fill(): filling window with '%s'"):format(self.id, char))

    local contents = {}

    for _ = 1, self.height do
        table.insert(contents, string.rep(char, self.width))
    end

    vim.api.nvim_buf_set_option(self.bufnr, "modifiable", true)
    vim.api.nvim_buf_set_option(self.bufnr, "readonly", false)

    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, contents)

    vim.api.nvim_buf_set_option(self.bufnr, "modifiable", false)
    vim.api.nvim_buf_set_option(self.bufnr, "readonly", true)
end

function Template:loop_start()
    local pass = Logger:assert(self.bufnr, ("[%s].loop_start(): window is not created"):format(self.id))
    if not pass then
        return
    end

    pass = Logger:assert(self.draw, ("[%s].loop_start(): draw function not set"):format(self.id))
    if not pass then
        return
    end

    if self.timer:is_active() then
        Logger:log(("[%s].loop_start(): timer already active"):format(self.id))
        return
    end

    self.timer:start(0, 1000 / self.frame_rate, self.draw)
end

function Template:loop_stop()
    local pass = Logger:assert(self.bufnr, ("[%s].loop_stop(): window is not created"):format(self.id))
    if not pass then
        return
    end

    if not self.timer:is_active() then
        Logger:log(("[%s].loop_stop(): timer already stopped"):format(self.id))
        return
    end

    self.timer:stop()
end

function Template:loop_toggle()
    local pass = Logger:assert(self.bufnr, ("[%s].loop_toggle(): window is not created"):format(self.id))
    if not pass then
        return
    end

    if self.timer:is_active() then
        self.timer:stop()
    else
        pass = Logger:assert(self.draw, ("[%s].loop_toggle(): draw function not set"):format(self.id))
        if not pass then
            return
        end

        self.timer:start(0, 1000 / self.frame_rate, self.draw)
    end
end

---@param setup function
---@param draw function
function Template:main(setup, draw)
    local pass = Logger:assert(self.bufnr, ("[%s].main(): window is not created"):format(self.id))
    if not pass then
        return
    end

    pass = Logger:assert(
        type(setup) == "function",
        ("[%s].main(): setup function not provided or is not a function"):format(self.id)
    )
    if not pass then
        return
    end

    pass = Logger:assert(
        type(draw) == "function",
        ("[%s].main(): draw function not provided or is not a function"):format(self.id)
    )
    if not pass then
        return
    end

    self.setup = setup
    self.draw = draw

    self.setup()
end

return Template
