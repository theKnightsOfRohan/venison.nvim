local Utils = {}

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

return Utils
