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

return Utils
