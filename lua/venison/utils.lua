---@class Utils
local Utils = {}

---@param orig table | nil
---@param seen table | nil
function Utils.deepcopy(orig, seen)
    seen = seen or {}

    if orig == nil then
        return nil
    end

    if seen[orig] then
        return seen[orig]
    end

    local orig_type = type(orig)
    local copy

    if orig_type == "table" then
        copy = {}
        seen[orig] = copy

        for orig_key, orig_value in next, orig, nil do
            copy[Utils.deepcopy(orig_key, seen)] = Utils.deepcopy(orig_value, seen)
        end

        setmetatable(copy, Utils.deepcopy(getmetatable(orig), seen))
    else
        copy = orig
    end

    return copy
end

---@param str string
---@return string
---@return number count
function Utils.trim(str)
    return str:gsub("^%s+", ""):gsub("%s+$", "")
end

---@param str string
---@return string
---@return number count
function Utils.remove_duplicate_whitespace(str)
    return str:gsub("%s+", " ")
end

---@param str string
---@param sep string
---@return table
function Utils.split(str, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for s in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, s)
    end
    return t
end

---@param str string
---@return boolean
function Utils.is_white_space(str)
    return str:gsub("%s", "") == ""
end

-- Overwrites the base string with the intersect string starting at the start index
--
-- If start is less than 1, then the intersect string's front is truncated to where the base string starts
--
-- If the intersect would go past the end of the base string, the rest is truncated
--
-- The returned string is always the same length as the base string
--
-- Examples:
-- intersect_string("abcdef", "123", 2) -> "a123ef"
--
-- intersect_string("abcdef", "123", 0) -> "23cdef"
--
-- intersect_string("abcdef", "123", 5) -> "abcd12"
---@param base string
---@param intersect string
---@param start number
---@return string res
function Utils.intersect_string(base, intersect, start)
    local res_table = { "", "", "" }

    if start < 1 then
        res_table[1] = ""
        res_table[2] = intersect:sub(-start + 2)
        res_table[3] = base:sub(#res_table[2] + 1)
    elseif start + #intersect > #base then
        res_table[1] = base:sub(1, start - 1)
        res_table[2] = intersect:sub(1, #base - #res_table[1])
        res_table[3] = ""
    else
        res_table[1] = base:sub(1, start - 1)
        res_table[2] = intersect
        res_table[3] = base:sub(start + #intersect)
    end

    return table.concat(res_table)
end

---@param bool boolean
---@return string
function Utils.bool_to_string(bool)
    if bool then
        return "true"
    else
        return "false"
    end
end

return Utils
