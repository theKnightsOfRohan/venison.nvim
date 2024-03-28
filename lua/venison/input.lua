local Utils = require("venison.utils")
local Logger = require("venison.logger")

---@class VenisonInputHandler
local Input = {}

-- Unbind all keymaps from the Venison window
---@param window VenisonWindow
function Input.unbind_all_keys(window)
    local pass = Logger:assert(window.win, "input.unbind_all_keys(): window is not created")
    if not pass then
        return
    end

    local bufnr = window.win.bufnr

    local modes = { "n", "v", "i", "x" }
    for _, mode in ipairs(modes) do
        local keys = vim.api.nvim_buf_get_keymap(bufnr, mode)
        for _, key in ipairs(keys) do
            if key.lhs ~= "" then
                vim.api.nvim_buf_del_keymap(bufnr, mode, key.lhs)
            end
        end
    end
end

---@class VenisonInputModifications
---@field start_line number
---@field start_col number
---@field contents string[]

---@param window VenisonWindow
---@param contents VenisonInputModifications
---@return boolean pass
function Input.insert_text_contents(window, contents)
    local bufnr = window.win.bufnr
    local win_width = window.win.width
    local win_height = window.win.height
    local res = true

    for i, line in ipairs(contents.contents) do
        local line_num = contents.start_line + i - 1
        local pass = Logger:assert(
            line_num <= win_height,
            string.format(
                "input.insert_text_contents(): line number of %d exceeds window height of %d",
                line_num,
                win_height
            )
        )
        if not pass then
            res = false
            break
        end

        pass = Logger:assert(
            line_num > 0,
            string.format("input.insert_text_contents(): line number of %d < 1", line_num)
        )
        if not pass then
            goto continue
        end

        local old_line_contents = vim.api.nvim_buf_get_lines(bufnr, line_num - 1, line_num, false)[1]

        pass = Logger:assert(
            #old_line_contents == win_width,
            "input.insert_text_contents(): line width does not match window width"
        )
        if not pass then
            res = false
            break
        end

        local start_col = contents.start_col + 1
        local new_line_contents = Utils.intersect_string(old_line_contents, line, start_col)

        pass = Logger:assert(new_line_contents ~= old_line_contents, "input.insert_text_contents(): no change detected")
        if not pass then
            goto continue
        end

        pass = Logger:assert(
            #new_line_contents == #old_line_contents,
            string.format(
                "input.insert_text_contents(): new line width does not match old line width: %d != %d",
                #new_line_contents,
                #old_line_contents
            )
        )
        if not pass then
            res = false
            break
        end

        vim.api.nvim_buf_set_lines(bufnr, line_num - 1, line_num, false, { new_line_contents })

        ::continue::
    end

    return res
end

---@param window VenisonWindow
---@param contents VenisonInputModifications
function Input.win_write_text(window, contents)
    local pass = Logger:assert(window.win, "input.modify_window_contents(): window is not created")
    if not pass then
        return
    end

    vim.api.nvim_buf_set_option(window.win.bufnr, "modifiable", true)
    vim.api.nvim_buf_set_option(window.win.bufnr, "readonly", false)

    pass = Input.insert_text_contents(window, contents)

    vim.api.nvim_buf_set_option(window.win.bufnr, "modifiable", false)
    vim.api.nvim_buf_set_option(window.win.bufnr, "readonly", true)

    if not pass then
        Logger:log("input.modify_window_contents(): modifications failed")
        return
    end

    Logger:log("input.modify_window_contents(): modifications applied")
end

return Input
